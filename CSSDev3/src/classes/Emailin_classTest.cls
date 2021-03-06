@isTest
private class Emailin_classTest {
    
    private static testMethod void myUnitTest() {
        Account acc = new Account(name='test acc',phone='9494146144');
        insert acc;
        
        //Assigning a record  type for particular record.
        Id RecordTypeIdFirstContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Parent').getRecordTypeId();
        Id RecordTypeIdSecondContact = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Companion').getRecordTypeId();
        
        Contact contactObj = new Contact(accountid=acc.id,lastname='test con',Email='sfdclatha@gmail.com',Prefered_First_Name__c='testcontact',RecordtypeId=RecordTypeIdFirstContact);
        insert contactObj;
        
        Contact contactObj1 = new Contact(accountid=acc.id,lastname='test1 con',Email='sfdclatha1@gmail.com',Prefered_First_Name__c='testcont',RecordtypeId=RecordTypeIdSecondContact);
        insert contactObj1;
        
        //system.debug('contact inserted');     
        //if Option2 not done, otherway we can set parent(__r) values as below. 
        //other wise lookup values wont get in code.
        course__c courseRec = new course__c(Practitioner__r=contactObj);
        courseRec.Course_Name__c='Antenatal';
        //courseRec.Status__c='Confirmed';
        courseRec.End_Date__c=date.today()+5;
       // courseRec.Course_End_Date__c= system.today();
        courseRec.Fee__c=4000.52;
        courseRec.Course_Type__c='NCT Parent';
        //courseRec.Venue__c=acc.id;
        courseRec.Practitioner__c=contactObj.id;
        insert courseRec;
        String cID = courseRec.id;
        
        Booking__c b1=new Booking__c();
        b1.First_Contact__c=contactObj.id;
        b1.Second_Contact__c=contactObj1.id;
        b1.Due_Date__c=system.today()+10;
        b1.Course__c=courseRec.id;
        b1.Status__c='Enquiry';
        insert b1;
        
       
       
        //system.debug('course courseRec'+courseRec); 
        //Option2 : to get lookup field courseRec.practitioner__r.Email, otherwise practitioner__r will be null 
        //must need to inset and then query for that same record:
        //courseRec = [select id,Practitioner__r.email from Course__c where id=:courseRec.Id];
        //system.debug('course practitioner__r.email : '+courseRec.practitioner__r.Email);        
        
        ApexPages.StandardController sc = new ApexPages.StandardController(courseRec);
        Emailin_class ec = new Emailin_class(sc);
        ec.toaddress = 'sfdclatha@gmail.com';
        ec.email_body= 'email_body';
        ec.subject='subject';
        ec.ccaddress='';
        PageReference page_Reference = ec.send();
        //system.debug('log courseRed.id : '+cID);
        // below assertion, after sending mail business expecting to redirect to Course Obj
        // hence checking the pagRef.URL to CourseID below.
        boolean expected = page_Reference.getUrl().contains('/'+cID.substring(0,cID.length()-3));
        system.assertEquals(true, expected);
    }
}