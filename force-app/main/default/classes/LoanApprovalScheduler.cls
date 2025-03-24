global class LoanApprovalScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        LoanApprovalBatch batch = new LoanApprovalBatch();
        Database.executeBatch(batch);
    }
}