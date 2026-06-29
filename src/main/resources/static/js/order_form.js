window.addEventListener("load", function () {
    const totalItemPriceInput = document.getElementById("totalItemPrice");
    const totalDeliveryFeeInput = document.getElementById("totalDeliveryFee");
    const pointBalanceInput = document.getElementById("pointBalance");

    const userCouponId = document.getElementById("userCouponId");
    const usePointInput = document.getElementById("usePointInput");
    const useAllPointBtn = document.getElementById("useAllPointBtn");

    const couponPriceText = document.getElementById("couponPriceText");
    const pointPriceText = document.getElementById("pointPriceText");
    const paymentPriceText = document.getElementById("paymentPriceText");

    if (totalItemPriceInput == null || totalDeliveryFeeInput == null || userCouponId == null) {
        return;
    }

    const totalItemPrice = Number(totalItemPriceInput.value || 0);
    const totalDeliveryFee = Number(totalDeliveryFeeInput.value || 0);
    const pointBalance = Number(pointBalanceInput != null ? pointBalanceInput.value || 0 : 0);

    function formatNumber(value) {
        return value.toLocaleString("ko-KR");
    }

    function getCouponPrice() {
        const selectedOption = userCouponId.options[userCouponId.selectedIndex];
        return Number(selectedOption.dataset.discount || 0);
    }

    function updatePaymentPrice() {
        const couponPrice = getCouponPrice();

        let basePaymentPrice = totalItemPrice + totalDeliveryFee - couponPrice;

        if (basePaymentPrice < 0) {
            basePaymentPrice = 0;
        }

        let usePointValue = 0;

        if (usePointInput != null) {
            usePointValue = Number(usePointInput.value || 0);

            if (isNaN(usePointValue) || usePointValue < 0) {
                usePointValue = 0;
            }

            if (usePointValue > pointBalance) {
                usePointValue = pointBalance;
            }

            if (usePointValue > basePaymentPrice) {
                usePointValue = basePaymentPrice;
            }

            usePointInput.value = usePointValue;
        }

        const finalPaymentPrice = basePaymentPrice - usePointValue;

        if (couponPriceText != null) {
            couponPriceText.innerText = "-" + formatNumber(couponPrice) + "원";
        }

        if (pointPriceText != null) {
            pointPriceText.innerText = "-" + formatNumber(usePointValue) + "원";
        }

        if (paymentPriceText != null) {
            paymentPriceText.innerText = formatNumber(finalPaymentPrice) + "원";
        }
    }

    userCouponId.addEventListener("change", updatePaymentPrice);

    if (usePointInput != null) {
        usePointInput.addEventListener("input", updatePaymentPrice);
    }

    if (useAllPointBtn != null) {
        useAllPointBtn.addEventListener("click", function () {
            const couponPrice = getCouponPrice();

            let basePaymentPrice = totalItemPrice + totalDeliveryFee - couponPrice;

            if (basePaymentPrice < 0) {
                basePaymentPrice = 0;
            }

            let maxUsePoint = pointBalance;

            if (maxUsePoint > basePaymentPrice) {
                maxUsePoint = basePaymentPrice;
            }

            if (usePointInput != null) {
                usePointInput.value = maxUsePoint;
            }

            updatePaymentPrice();
        });
    }

    updatePaymentPrice();
});