public with sharing class CibilScoreController {
    @AuraEnabled(cacheable=true)
    public static Map<String, Object> getCibilScore() {
        Integer minScore = 650;
        Integer maxScore = 900;
        Integer cibilScore = (Integer)(Math.random() * (maxScore - minScore + 1)) + minScore;
        String riskCategory;
        if (cibilScore >= 650 && cibilScore <= 700) {
            riskCategory = 'High Risk';
        } else if (cibilScore > 700 && cibilScore <= 800) {
            riskCategory = 'Medium Risk';
        } else {
            riskCategory = 'Low Risk';
        }
        Map<String, Object> result = new Map<String, Object>();
        result.put('cibilScore', cibilScore);
        result.put('riskCategory', riskCategory);
        return result;
    }
}