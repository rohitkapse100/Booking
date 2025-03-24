public class PerformanceReviewSharing {
    //
    /*public static void shareReviewWithHR(List<Performance_Review__c> reviews) {
        List<Performance_Review__Share> shares = new List<Performance_Review__Share>();
        for (Performance_Review__c review : reviews) {
            List<User> hrUsers = [SELECT Id, Profile.Name FROM User WHERE Profile.Name IN ('HR Manager', 'HR Coordinator')];
            for (User hrUser : hrUsers) {
                Performance_Review__Share shareRecord = new Performance_Review__Share();
                shareRecord.ParentId = review.Id;
                shareRecord.UserOrGroupId = hrUser.Id;
                shareRecord.AccessLevel = hrUser.Profile.Name == 'HR Manager' ? 'Edit' : 'Read';
                shareRecord.RowCause = Schema.Performance_Review__Share.RowCause.Manual;
                shares.add(shareRecord);
            }
        }
        if (!shares.isEmpty()) {
            insert shares;
        }
    }*/
}