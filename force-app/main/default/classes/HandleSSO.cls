/****************************************************************************************
Class Name  : HandleSSO         
Author      : ITC
Date        : Jan 26,2022
*****************************************************************************************/

global class HandleSSO implements Auth.SamlJitHandler
{
    private void handleUser(boolean create, User u, Map<String, String> attributes, String federationIdentifier)
    {
        System.debug('**** Attributes: <'+attributes.keySet()+'>');

        if(create && attributes.containsKey('User.Username'))
        {
            u.Username = attributes.get('User.Username');
        }

        if(create && attributes.containsKey('User.LastName'))
        {
            u.LastName = attributes.get('User.LastName');
        }

        if(create && attributes.containsKey('User.FirstName'))
        {
            u.FirstName = attributes.get('User.FirstName');
        }

        if(create && attributes.containsKey('User.Alias'))
        {
            u.Alias = attributes.get('User.Alias');
        }

        if(create)
        {
            if(attributes.containsKey('User.FederationIdentifier'))
            {
                u.FederationIdentifier = attributes.get('User.FederationIdentifier');
            }
            else
            {
                u.FederationIdentifier = federationIdentifier;
            }
        }

        // If there is not profileId after this section, the User create will fail. That's ok. No default logic.
        if(attributes.containsKey('User.ProfileId'))
        {
            String profileId = attributes.get('User.ProfileId');
            System.debug('**** ProfileId: '+profileId);
            try
            {
                Profile p = [SELECT Id FROM Profile WHERE Id=:profileId]; // if what's passed in is an Id
                u.ProfileId = p.Id;
            }
            catch(Exception ex)
            {
                System.debug('**** ProfileId Excep 1: '+ex.getMessage());
              
            }
        }

        if(attributes.containsKey('User.UserRoleId'))
        {
            String userRole = attributes.get('User.UserRoleId');
            UserRole r = [SELECT Id FROM UserRole WHERE Id=:userRole];
            u.UserRoleId = r.Id;
        }

        if(attributes.containsKey('User.Phone'))
        {
            u.Phone = attributes.get('User.Phone');
        }

        if(attributes.containsKey('User.Email')) {
            u.Email = attributes.get('User.Email');
        }

        if(create)
        {
            u.TimeZoneSidKey = 'America/El_Salvador';
            u.LanguageLocaleKey = 'en_US';
            u.LocaleSidKey = 'en_US';
            u.EmailEncodingKey = 'UTF-8';
        }

        if(!create)
        {
            update(u);
        }
    }

    private void handleJit(boolean create, User u, Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier,
            Map<String, String> attributes, String assertion)
    {
        handleUser(create, u, attributes, federationIdentifier);
    }

    global User createUser(Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier,
            Map<String, String> attributes, String assertion)
    {
        User u = new User();
        handleJit(true, u, samlSsoProviderId, communityId, portalId, federationIdentifier, attributes, assertion);
        return u;
    }

    global void updateUser(Id userId, Id samlSsoProviderId, Id communityId, Id portalId, String federationIdentifier,
            Map<String, String> attributes, String assertion)
    {
        // Empty. We don't want to update anything
    }
}