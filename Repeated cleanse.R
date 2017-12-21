# Login
library(RForcecom)
username <- "admin@andes.org"
password <- "gfadm913XQWRiDpPU6NzJC9Cmm185FF2"
session <- rforcecom.login(username, password)

# Salesforce reports with repeated records
# Diagnostic: https://taroworks-8629.cloudforce.com/00O36000005Gzcp
# Follow up: https://taroworks-8629.cloudforce.com/00O36000007BEYe

# Delete M&E diagnostic repeated records --------------------------------------------


# Retrieve M&E Diagnostic records to delete
diagme.records <- rforcecom.retrieve(session, 
                                     "FMP_Diagnostics_Targets_Definition_MYE__c", 
                                     "Id")
diag.query <- "SELECT Id FROM FMP_Diagnostics_Targets_Definition_MYE__c WHERE Last_parent_record_update__c = 0 LIMIT -5"
diag.rep <- rforcecom.query(session, diag.query)

# Delete records
# run an insert job
job_info <- rforcecom.createBulkJob(session, 
                                    operation='delete', 
                                    object='FMP_Diagnostics_Targets_Definition_MYE__c')
# split into batch sizes of 500
batches_info <- rforcecom.createBulkBatch(session, 
                                          jobId=job_info$id, 
                                          diag.rep, 
                                          multiBatch = TRUE, 
                                          batchSize = 500)
# close job
Close_job_info <- rforcecom.closeBulkJob(session, jobId = job_info$id)
