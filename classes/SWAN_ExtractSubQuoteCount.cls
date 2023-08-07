//Test class: SWAN_OverlapSPTest
global with sharing class SWAN_ExtractSubQuoteCount implements vlocity_cmt.VlocityOpenInterface {

    /**
        * Top level call by a Vlocity Remote Action
        *
        * @param inputMap  - The input provided to the Remote Action
        * @param outputMap - Any output to be provided back to the Remote Action
        * @param options   - Any options to aid in the execution of this class
        *
        * @returns true if the method completes successfully, false otherwise
        */ 
    global Boolean invokeMethod(String methodName, Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {

        Boolean result = true;
        try
        {
            if (methodName.equals('getSubQuoteCount'))
            {
                getSubQuoteCount(inputMap,outputMap,options);
            }
            if (methodName.equals('createContract'))
            {
                createContract(inputMap,outputMap,options);
            }
            if (methodName.equals('updateServicePointStatus'))
            {
                updateServicePointStatus(inputMap,outputMap,options);
            }
            if (methodName.equals('updateSelectedServicePointStatus'))
            {
                updateSelectedServicePointStatus(inputMap,outputMap,options);
            }
            if (methodName.equals('haveRequiredEMRContacts'))
            {
                haveRequiredEMRContacts(inputMap,outputMap,options);
            }
            else 
            {
                result = false;
            }   
        } 
        catch(Exception e)
        {System.debug('SWAN_ExtractSubQuoteCount:invokeMethod -> exception: '+e);
            result = false;}
        
        return result;
        
    }
    
    global Boolean getSubQuoteCount(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
        /*List<Object> subQuotes = new List<Object>();
    List<Object> subQuotesQLI = new List<Object>();*/
        String masterQuoteId = String.ValueOf(inputMap.get('ContextId'));
        /*for(Quote childQuote : [SELECT id,swan_parent_quote__c,opportunityid,status,accountid,swan_broker_commission__c,swan_commission_payment_period__c,email,name,swan_pricing_structure__c,swan_productid__c,swan_annual_spend__c,swan_broker__c,swan_broker_commission_margin_p__c,swan_broker_commission_margin_pence_per__c,swan_broker_commission_as_pc__c,swan_broker_commission_margin_unit__c,swan_contract_volume_kwh__c,swan_service_point_end_date__c,swan_service_point_start_date__c,pricebook2id,description,discount,recordtypeid,swan_service_point__c,swan_broker__r.commission_payment_period__c,swan_commodity__c,swan_commodity_as_pc__c,swan_contract_spend__c,swan_contribution_margin_p__c,swan_contribution_margin_unit__c,swan_contribution_margin_pc__c,swan_contribution_margin_pence_per__c,swan_cost_to_serve__c,swan_gross_margin__c,swan_gross_margin_pc__c,swan_justification_comment__c,swan_justification_reasons__c,swan_metering__c,swan_metering_as_pc__c,swan_non_commodity_as_pc__c,swan_number_of_service_points__c,swan_offer_duration__c,swan_offer_end_date__c,swan_offer_start_date__c,swan_parent_opportunity__c,swan_payment_method__c,swan_payment_term__c,vlocity_cmt__pricelistid__c,vlocity_cmt__pricelistid__r.name,swan_price_out_of_date__c,swan_quote_for_fuel_type__c,recordtype.name,swan_payment_method_and_term__c,swan_standing_charge_as_split__c,swan_unit_rate_as_split__c,swan_sales_channel__c FROM Quote WHERE SWAN_Parent_Quote__c = :masterQuoteId])
    {
            Map<String, Object> eachRec = pushEachRecord(childQuote);
            subQuotes.add(eachRec);
    }   */

        Integer sub_Quotes_Size= [Select COUNT() from Quote WHERE vlocity_cmt__ParentQuoteId__c = :masterQuoteId AND Recordtype.DeveloperName != 'GroupCart'];
        if(sub_Quotes_Size > 0)
        {
            outputMap.put('sub_Quotes_Size',sub_Quotes_Size);
        }
        else{outputMap.put('sub_Quotes_Size',0);}
        
        
        
        return true;
    }
    
    global Boolean createContract(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
        String masterQuoteId = String.ValueOf(inputMap.get('ContextId'));
        /*for(Quote childQuote : [SELECT id,swan_parent_quote__c,opportunityid,status,accountid,swan_broker_commission__c,swan_commission_payment_period__c,email,name,swan_pricing_structure__c,swan_productid__c,swan_annual_spend__c,swan_broker__c,swan_broker_commission_margin_p__c,swan_broker_commission_margin_pence_per__c,swan_broker_commission_as_pc__c,swan_broker_commission_margin_unit__c,swan_contract_volume_kwh__c,swan_service_point_end_date__c,swan_service_point_start_date__c,pricebook2id,description,discount,recordtypeid,swan_service_point__c,swan_broker__r.commission_payment_period__c,swan_commodity__c,swan_commodity_as_pc__c,swan_contract_spend__c,swan_contribution_margin_p__c,swan_contribution_margin_unit__c,swan_contribution_margin_pc__c,swan_contribution_margin_pence_per__c,swan_cost_to_serve__c,swan_gross_margin__c,swan_gross_margin_pc__c,swan_justification_comment__c,swan_justification_reasons__c,swan_metering__c,swan_metering_as_pc__c,swan_non_commodity_as_pc__c,swan_number_of_service_points__c,swan_offer_duration__c,swan_offer_end_date__c,swan_offer_start_date__c,swan_parent_opportunity__c,swan_payment_method__c,swan_payment_term__c,vlocity_cmt__pricelistid__c,vlocity_cmt__pricelistid__r.name,swan_price_out_of_date__c,swan_quote_for_fuel_type__c,recordtype.name,swan_payment_method_and_term__c,swan_standing_charge_as_split__c,swan_unit_rate_as_split__c,swan_sales_channel__c FROM Quote WHERE SWAN_Parent_Quote__c = :masterQuoteId])
    {
            Map<String, Object> eachRec = pushEachRecord(childQuote);
            subQuotes.add(eachRec);
    }   */
        try{
            Database.executeBatch(new SWAN_CreateContractBatch(masterQuoteId,UserInfo.getUserId()),500);
            return true;
        }
        catch(exception e){
            return false;
        } 
    }
    
    global Boolean updateServicePointStatus(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
        String process_Name = String.ValueOf(inputMap.get('Processname'));
        String final_status = String.ValueOf(inputMap.get('FinalStatus'));
        String needForMap= String.ValueOf(inputMap.get('NeedForMap'));
        String terminatedEndDateTime = String.ValueOf(inputMap.get('TerminatedEndDateTime'));
        Object selectServicePoint = inputMap.get('SelectServicePoints');
        Object contractLineItem;
        List<Object> contractLineItem_list;

        if(needForMap=='false'){
            contractLineItem_list= (List<Object>)inputMap.get('ContractLineItem');
        }else{
            try {
                Map<String, Object> selectServicePoint_map = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(selectServicePoint));
                Map<String, Object> selectServicePoint_map2 = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(selectServicePoint_map.get('lwcContractLineItem')));
                
                contractLineItem = selectServicePoint_map2.get('ContractLineItem');
                contractLineItem_list = (List<Object>)contractLineItem;
            } catch(Exception e) {
                System.debug(e.getMessage());
            }
        }

        Set<Id> cli_Id_List = new Set<Id>();

        for(Object obj : contractLineItem_list){
            Map<String, Object> contractLineItemId_map = (Map<String, Object>)obj;
            
            Object contractLineItemId = contractLineItemId_map.get('Contract_Line_Item_Id');
            cli_Id_List.add((Id)contractLineItemId);
        }

        try{
            if(process_Name == 'Cancelled'){
                Database.executeBatch(new SWAN_updateSPStatusCancelledBatch(cli_Id_List,UserInfo.getUserId(),process_Name),1000);
            }else if(process_Name == 'Termination'){
                Database.executeBatch(new SWAN_updateSPStatusCancelledBatch(cli_Id_List,UserInfo.getUserId(),final_status,terminatedEndDateTime,process_Name),1000);
            }
            return true;
        }
        catch(exception e){
            return false;
        }
    }

    global Boolean updateSelectedServicePointStatus(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options) {
        String process_Name = String.ValueOf(inputMap.get('Processname'));
        String final_status = String.ValueOf(inputMap.get('FinalStatus'));
        String terminatedEndDateTime = String.ValueOf(inputMap.get('TerminatedEndDateTime'));
        List<Object> contractLineItem_list= (List<Object>)inputMap.get('SelectedSpsJson');
        Set<Id> cli_Id_List = new Set<Id>();
        
        for(Object obj : contractLineItem_list){
            Map<String, Object> contractLineItemId_map = (Map<String, Object>)obj;
            
            Object contractLineItemId = contractLineItemId_map.get('Contract_Line_Item_Id');
            cli_Id_List.add((Id)contractLineItemId);
        }

        try{
            if(process_Name == 'Cancelled'){
                Database.executeBatch(new SWAN_updateSPStatusCancelledBatch(cli_Id_List,UserInfo.getUserId(),process_Name),1000);
            }else if(process_Name == 'Termination'){
                Database.executeBatch(new SWAN_updateSPStatusCancelledBatch(cli_Id_List,UserInfo.getUserId(),final_status,terminatedEndDateTime,process_Name),1000);
            }
            return true;
        }
        catch(exception e){
            return false;
        }
    }
    
    global Boolean haveRequiredEMRContacts(Map<String, Object> inputMap, Map<String, Object> outputMap, Map<String, Object> options){
        String quoteRecordTypeId = String.valueOf(inputMap.get('QuoteRecordTypeId'));
        String masterQuoteId = String.valueOf(inputMap.get('ContextId'));
        Date contractStarDate = Date.valueOf(String.valueOf(inputMap.get('OfferStartDate')));
        String accountId = String.valueOf(inputMap.get('AccountId'));
        Set<Id> qtChildPremisesList = new Set<Id>();
        Id recId = Schema.SObjectType.Quote.getRecordTypeInfosByName().get('Site Addition Quote').getRecordTypeId();
        
        try{
            //List to get all sub quotes from master quote from contract
            List<Quote> masterQuoteList = new List<Quote>([SELECT id,
            (SELECT Id,vlocity_cmt__DefaultServicePointId__r.vlocity_cmt__PremisesId__c 
            FROM vlocity_cmt__Quotes__r WHERE Recordtype.Developername != 'GroupCart' AND vlocity_cmt__DefaultServicePointId__c != null
            AND SWAN_Quote_for_Fuel_Type__c = 'Gas') 
            FROM Quote WHERE Id = :masterQuoteId AND SWAN_Quote_for_Fuel_Type__c = 'Gas']);
            
            if(!masterQuoteList.isEmpty()){
                //List to get all Premises from sub quotes from master quote from contract
                for(Quote q : masterQuoteList) {
                    for(Quote cq : q.vlocity_cmt__Quotes__r) {
                        qtChildPremisesList.add(cq.vlocity_cmt__DefaultServicePointId__r.vlocity_cmt__PremisesId__c);
                    }
                }
    
                //List to get all Service Accounts from all the Premises from all sub quotes from the master quote from the contract
                for(Account sa : [SELECT Id,SWAN_Correct_Number_Emergency_Contacts__c FROM Account WHERE Type = 'Gas' AND ParentId = :accountId
                                  AND RecordType.DeveloperName = 'Service' AND vlocity_cmt__PremisesId__c = :qtChildPremisesList]){
                    if(quoteRecordTypeId == recId){
                        if(!sa.SWAN_Correct_Number_Emergency_Contacts__c){
                            outputMap.put('hasCorrectEMRContacts',false);
                            return false;
                        }
                    }else{
                        if(system.today().daysBetween(contractStarDate) <= NumberOfDays__mdt.getInstance('OfferStartDate').Days__c){
                            if(!sa.SWAN_Correct_Number_Emergency_Contacts__c){
                                outputMap.put('hasCorrectEMRContacts',false);
                                return false;
                            }
                        }
                    }
                }
            }

            outputMap.put('hasCorrectEMRContacts',true);
            return true;
        }catch(exception e){
            System.debug('Exception SWAN_ExtractSubQuoteCount.haveRequiredEMRContacts method: ' + e.getMessage());
            outputMap.put('hasCorrectEMRContacts',false);
            return false;
        } 
    }
}