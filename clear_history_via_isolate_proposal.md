# [# Issue 551](https://github.com/foss42/apidash/issues/551)
Clear History of saved API results using Isolate.

## Proposed Solution

Here is my proposal inorder to resolve clearing API by offloading the task from main thread. 

P.S - I may be thinking out loud while drafting this.

### Trigger Logic

+ On App Launch - Simple Init method to schedule a job and check local records which are dirty.
+ On Intervals - During late evenings or times when app is not heavily run (Problems - App could be closed, paused in the background)
+ On New API Result Added - When new API record is saved to database, then trigger for clean up (just like LRU Cache Management)
+ On App Closed - We may need to notify the user and there could be possible delay in closing the application (May seem bad idea here.)

### Technical Findings

+ Hive transactions are usually fast upto moderate datasets, We can initiate complete depedency on Isolate functions when datasets are huge (How do we ballpark this decision factor?) until then we may rely on Compute or [SchedulerBinding.scheduleTask](https://api.flutter.dev/flutter/foundation/compute.html).

### Edge Cases Considerations

+ if in future APIDASH features collection based folders, we may need to be mindful about deleting the records via batch processing since we quite know the records could be too many for particular project/collection.


### Mindful Consideration

+ User may want to use history saved API while cleaning process is initiated, although the local db transaction blazing fast, we may better optimise to lock the history pane while process is in due. (Est. Few milliseconds)

### Work Flow
+ From the decided trigger logic mentioned above, initiate local search from hive for all the records EXCEPT enum.FOREVER()

+ If the data records are not too many, with the use of compute function we asynchronously delete all the records.

+ Show loader on UI while clean up is happening. (if we allow users to move to history pane).


### My Recommendations

+ Lets use compute for background cleanup tasks.

+ Lets trigger cleanup on app launch.

+ Handle large datasets via batch processing to avoid blocking execution.


### Please do let me know if there is anything that I've missed.


