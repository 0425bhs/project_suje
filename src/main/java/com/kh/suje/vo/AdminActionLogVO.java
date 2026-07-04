package com.kh.suje.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("actionLog")
public class AdminActionLogVO {
    private int log_id, target_id;
    private Integer admin_id;
    private String target_type, action_type, before_status, after_status, memo, created_at;

    private String admin_name;

    public String getBeforeStatusLabel() {
        return getStatusLabel(before_status);
    }

    public String getAfterStatusLabel() {
        return getStatusLabel(after_status);
    }

    private String getStatusLabel(String status) {
        if (status == null || status.trim().isEmpty()) {
            return "없음";
        }

        String targetType = target_type == null ? "" : target_type.toUpperCase();
        String statusKey = status.toUpperCase();

        if ("MEMBER".equals(targetType)) {
            switch (statusKey) {
                case "ACTIVE":
                    return "활성";
                case "SUSPENDED":
                    return "정지";
                case "WITHDRAWN":
                    return "탈퇴";
                default:
                    return "알 수 없음";
            }
        }

        if ("SELLER".equals(targetType)) {
            switch (statusKey) {
                case "PENDING":
                    return "승인대기";
                case "APPROVED":
                    return "승인완료";
                case "REJECTED":
                    return "반려";
                default:
                    return "알 수 없음";
            }
        }

        if ("PRODUCT".equals(targetType)) {
            switch (statusKey) {
                case "PENDING":
                    return "승인대기";
                case "APPROVED":
                    return "판매중";
                case "REJECTED":
                    return "반려";
                case "HIDDEN":
                    return "숨김";
                default:
                    return "알 수 없음";
            }
        }

        if ("ORDER".equals(targetType)) {
            switch (statusKey) {
                case "PENDING":
                    return "결제대기";
                case "PAID":
                    return "결제완료";
                case "PREPARING":
                    return "배송준비";
                case "SHIPPING":
                    return "배송중";
                case "DELIVERED":
                    return "배송완료";
                case "CANCELLED":
                    return "취소";
                default:
                    return "알 수 없음";
            }
        }

        if ("INQUIRY".equals(targetType)) {
            switch (statusKey) {
                case "WAITING":
                    return "미답변";
                case "ANSWERED":
                    return "답변완료";
                default:
                    return "알 수 없음";
            }
        }

        if ("REPORT".equals(targetType)) {
            switch (statusKey) {
                case "PENDING":
                    return "처리대기";
                case "PROCESSED":
                    return "처리완료";
                case "REJECTED":
                    return "반려";
                default:
                    return "알 수 없음";
            }
        }

        return "알 수 없음";
    }
}
