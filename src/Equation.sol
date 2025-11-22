// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

// Signed
// import { SD59x18, convert } from "@prb/math/src/SD59x18.sol";
import { SD59x18, sd } from "@prb/math/src/SD59x18.sol";

import { UD60x18, wrap, unwrap } from "prb-math/UD60x18.sol";
import { pow, mul, div, ln } from "prb-math/ud60x18/Math.sol";
// // Unsigned
// import { UD60x18 , convert } from "@prb/math/src/UD60x18.sol"; 

contract Equation {

    uint256 private constant WAD = 1e18;
        // Probability in WAD (e.g., 0.66e18 for 66%)
    uint256 public pYesWad;

    // function discharge() public pure returns (int256 result) {

    //     // prb-math conversion methods:
    //     // sd = input is already scaled by multiplying by 1 ether
    //     // convert = unscaled input that will be scalled multiplying value by 1 ether
        
    //     SD59x18 negativeOne = sd(-1 ether);
    //     SD59x18 xReserve = sd(10 ether);
    //     SD59x18 yReserve = sd(0 ether);
    //     SD59x18 Dx = sd(1 ether);
    //     SD59x18 a = sd(10 ether);
    //     SD59x18 c = sd(10 ether);
    //     SD59x18 b = sd(0 ether);
    //     SD59x18 lnInputDenominator = c - b;
    //     SD59x18 lnInputNumerator = (xReserve - Dx ) - b;
    //     SD59x18 lnInput = lnInputNumerator.div(lnInputDenominator);
    //     // SD59x18 lnInput = sd(0.444444444444444444 ether);
    //     SD59x18 lnExpression = lnInput.ln();
    //     // SD59x18 lnExpression = sd(-0.810930216216328753 ether);
    //     SD59x18 lnExpressionScaled = lnExpression.mul(a);
    //     SD59x18 lnExpressionScaledSigned = lnExpressionScaled.mul(negativeOne);
    //     SD59x18 resultWrapped = lnExpressionScaledSigned - yReserve;
    //     result = SD59x18.unwrap(resultWrapped);
    //     return result;

    // }

    // function charge() public pure returns (int256 result) {

    //     // prb-math conversion methods:
    //     // sd = input is already scaled by multiplying by 1 ether
    //     // convert = unscaled input that will be scalled multiplying value by 1 ether

    //     SD59x18 negativeOne = sd(-1 ether);
    //     SD59x18 xReserve = sd(10 ether);
    //     SD59x18 a = sd(10 ether);
    //     SD59x18 b = sd(0 ether);
    //     SD59x18 Dy = sd(1 ether);
    //     SD59x18 factor_a = xReserve - b;
    //     // SD59x18 factor_a = sd(10 ether);
    //     SD59x18 one = sd(1 ether);
    //     SD59x18 exp_input = Dy.div(a);
    //     // SD59x18 exp_input = sd(0.1 ether);
    //     SD59x18 exp_expression = exp_input.exp();
    //     // SD59x18 exp_expression = sd(1.10517091808 ether);
    //     SD59x18 factor_b = one - exp_expression;
    //     // SD59x18 factor_b = sd(-1.05170918076 ether);
    //     SD59x18 product = factor_a.mul(factor_b);
    //     SD59x18 resultWrapped = product.mul(negativeOne);
    //     result = SD59x18.unwrap(resultWrapped);
    //     return result;
    // }

    // --- Math helpers for swaps on K = x^p * y^(1-p) ---
    function _powSegmentedIfNeeded(UD60x18 base, UD60x18 exponent) internal pure returns (UD60x18) {
        // Only segment when base >= 1 to keep ln(base) >= 0
        if (unwrap(base) < WAD) {
            return pow(base, exponent);
        }
        UD60x18 lr = ln(base); // ln(base) >= 0
        UD60x18 l1Thresh = wrap(6e18);
        UD60x18 l2Thresh = wrap(12e18);
        UD60x18 lw = mul(lr, exponent);

        if (unwrap(lw) <= unwrap(l1Thresh)) {
            return pow(base, exponent);
        } else if (unwrap(lw) <= unwrap(l2Thresh)) {
            UD60x18 half = wrap(unwrap(exponent) / 2);
            UD60x18 t = pow(base, half);
            return mul(t, t);
        } else {
            UD60x18 quarter = wrap(unwrap(exponent) / 4);
            UD60x18 t = pow(base, quarter);
            return mul(mul(t, t), mul(t, t));
        }
    }

    function _solveYGivenKAndX(uint256 k0, uint256 xPrime) internal view returns (uint256 yPrime) {
        // y' = (K / x'^p)^(1/(1-p))
        require(xPrime > 0, "x'=0");
        // p in (0,1) guaranteed by initialize() constraints
        UD60x18 xU = wrap(xPrime);
        UD60x18 pU = wrap(pYesWad);
        UD60x18 oneMinusP = wrap(WAD - pYesWad);

        // x'^p
        UD60x18 xPow = pow(xU, pU);
        // ratio = K / x'^p
        UD60x18 ratio = div(wrap(k0), xPow);
        // exponent = 1/(1-p)
        UD60x18 invW = div(wrap(WAD), oneMinusP);

        UD60x18 yU;
        if (unwrap(ratio) >= WAD) {
            yU = _powSegmentedIfNeeded(ratio, invW);
        } else {
            yU = pow(ratio, invW);
        }
        yPrime = unwrap(yU);
    }

    function _solveXGivenKAndY(uint256 k0, uint256 yPrime) internal view returns (uint256 xPrime) {
        // x' = (K / y'^(1-p))^(1/p)
        require(yPrime > 0, "y'=0");
        UD60x18 yU = wrap(yPrime);
        UD60x18 oneMinusP = wrap(WAD - pYesWad);
        UD60x18 pU = wrap(pYesWad);

        // y'^(1-p)
        UD60x18 yPow = pow(yU, oneMinusP);
        // ratio = K / y'^(1-p)
        UD60x18 ratio = div(wrap(k0), yPow);
        // exponent = 1/p
        UD60x18 invP = div(wrap(WAD), pU);

        UD60x18 xU;
        if (unwrap(ratio) >= WAD) {
            xU = _powSegmentedIfNeeded(ratio, invP);
        } else {
            xU = pow(ratio, invP);
        }
        xPrime = unwrap(xU);
    }

}