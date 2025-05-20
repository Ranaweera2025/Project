package model;

import java.util.List;

public class PrescriptionOrder extends Order {
    private String prescriptionId;
    private boolean verified;

    public PrescriptionOrder(String orderId, String userId, List<String> productIds,
                             double totalAmount, String prescriptionId) {
        super(orderId, userId, productIds, totalAmount);
        this.prescriptionId = prescriptionId;
        this.verified = false;
        super.setStatus("AWAITING_VERIFICATION");
    }

    public String getPrescriptionId() { return prescriptionId; }
    public boolean isVerified() { return verified; }
    public void verifyPrescription() {
        this.verified = true;
        super.setStatus("PROCESSING");
    }
}