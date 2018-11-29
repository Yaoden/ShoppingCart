public with sharing class DisplayMaterialsContoller {

    public String Price { get; set; }

    public String MaterialName { get; set; }
    //public string Name__c{get;set;}
    //public string 
    //string[] materials = new string;
    public list<Integer> quantity{get;set;}
    public list<Material__c> materialsList{get;set;}
    
    public DisplayMaterialsContoller () {
        materialsList = [select Name__c, Price__c, Category__c from Material__c];
        /*
        for(Integer i=1; i<11; i++) {
            quantity.add(i);
        }*/
        
    }
}