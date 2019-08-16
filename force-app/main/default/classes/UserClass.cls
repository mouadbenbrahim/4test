public class UserClass {

    Public static void AssgnPermSet(Map<Id, User> news, Map<Id, User> olds, string Operation){

		string rolename;
		Id permsetid;        
        
        system.debug('THA dans class ');
        
        List<Id> ids = new list<Id>();
        List <PermissionSetAssignment> psaS = new List <PermissionSetAssignment>();
        //List <PermissionSet> psS = new List <PermissionSet>();
        
        Map<Id,UserRole> roleMap = new Map<Id,UserRole>();
        // Map<string,PermissionSet> pmsetMap = new Map<string,PermissionSet>();
        
/*		Pas besoin de la boucle si la liste n'est pas grande (ex. user)
 		for (Id sid:news.keySet())
        {
            roleMap.put(news.get(sid).UserRoleId, null);
        }
        roleMap.remove(null);
*/

        //roleMap.putAll([select Id, Name from UserRole where Id in : roleMap.keySet()]);
        roleMap.putAll([select Id, Name from UserRole]);
                
        // ne fonctionne pas : pb d'avoir la cle (label au lieu d'un id)
        // pmsetMap.putAll([select Label, Id from PermissionSet where Label = 'Product supervisor']); 
        
            
        for (Id sid:news.keySet())
        {
            system.debug('THA dans boucle ' + 'AssignId ' + sid + 'new role ' + news.get(sid).UserRoleId + ' old role ' + olds.get(sid).UserRoleId);
            if (Operation == 'UPDATE' && news.get(sid).UserRoleId != olds.get(sid).UserRoleId ){
                
                // AjouterUserdansPermSet
                rolename = roleMap.get(news.get(sid).UserRoleId).Name;                
				PermissionSet[] psS = [select id from PermissionSet where Label = :rolename]; // affectation par tableau
                if (psS.size() > 0) permsetid = psS[0].id;
                // permsetid = [select id from PermissionSet where Label = :rolename].Id; // erreur si 0 ligne renvoye, il faut utiliser un tableau ou liste
                // permsetid = pmsetMap.get(rolename).Id;  ne fonctionne pas : pb d'avoir la cle (label au lieu d'un id)
                if (rolename != null && permsetid != null)
                {
                    PermissionSetAssignment psa = new PermissionSetAssignment(PermissionSetId = permsetid, AssigneeId = sid);
                    system.debug('THA dans boucle if update ' + 'AssignId ' + sid);
                    psaS.add(psa);
                }
                    
                //SupprimerAncienDansPermSet                
                // A FAIRE 
            }                                       
        }
        if (!psaS.isEmpty()) Database.insert(psaS);                
    }
    
    
}