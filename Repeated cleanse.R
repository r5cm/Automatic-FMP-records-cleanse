# Login
library(RForcecom)
username <- "admin@andes.org"
password <- "gfadm913XQWRiDpPU6NzJC9Cmm185FF2"
session <- rforcecom.login(username, password)

# Salesforce reports with repeated records
# Diagnostic: https://taroworks-8629.cloudforce.com/00O36000005Gzcp
# Follow up: https://taroworks-8629.cloudforce.com/00O36000007BEYe

# Delete M&E diagnostic repeated records --------------------------------------------

# ATTENTION: DISABLE PROCESS BEFORE DELETING RECORDS!!

# Retrieve M&E Diagnostic records to delete
diag.query <- "SELECT Id FROM FMP_Diagnostics_Targets_Definition_MYE__c WHERE Last_parent_record_update__c = 0 ORDER BY FMP_Diagnostic_And_Target_Definition__c"
diag.rep <- rforcecom.query(session, diag.query)

# Delete records
# run an insert job
job_info <- rforcecom.createBulkJob(session, 
                                    operation='delete', 
                                    object='FMP_Diagnostics_Targets_Definition_MYE__c')
# split into batch sizes of 100
batches_info <- rforcecom.createBulkBatch(session, 
                                          jobId=job_info$id, 
                                          diag.rep, 
                                          multiBatch = TRUE, 
                                          batchSize = 100)
# close job
Close_job_info <- rforcecom.closeBulkJob(session, jobId = job_info$id)

# s

# Delete M&E Follow up repeated records ---------------------------------------------

# Retrieve Follow up records to delete
fu.query <- "SELECT Id FROM FMP_Follow_Up_M_E__c WHERE Last_parent_record_update__c = 0 ORDER BY FMP_Follow_Up__c"
fu.rep <- rforcecom.query(session, fu.query)

# Delete records
# run an insert job
job_info <- rforcecom.createBulkJob(session, 
                                    operation='delete', 
                                    object='FMP_Follow_Up_M_E__c')
# split into batch sizes of 500
batches_info <- rforcecom.createBulkBatch(session, 
                                          jobId=job_info$id, 
                                          fu.rep, 
                                          multiBatch = TRUE, 
                                          batchSize = 500)
# close job
Close_job_info <- rforcecom.closeBulkJob(session, jobId = job_info$id)
