public class MEAUtils {
      /**********************************************************
   *  Helper Method: wait
   *  @param Integer millisec : time for wait (millisecond)
   *********************************************************/
  public static void wait(Integer millisec) {
    
    if(millisec == null || millisec < 0) {
      millisec = 0;
    }
      
    Long startTime = DateTime.now().getTime();
    Long finishTime = DateTime.now().getTime();
    while ((finishTime - startTime) < millisec) {
      //sleep for parameter x millisecs
      finishTime = DateTime.now().getTime();
    }
    // System.debug('>>> Done from ' + startTime + ' to ' + finishTime);
  }
    
    public static List<String> removelistduplicate(List<String> mylist) {
        
        Set<String> myset = new Set<String>();
        List<String> result = new List<String>();
        myset.addAll(mylist);
        result.addAll(myset);
		return result;              
    }
    
    
      
    }