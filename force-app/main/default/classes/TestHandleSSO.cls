/****************************************************************************************
Class Name  : Test_HandleSSO         
Author      : ITC
Date        : Jan 26,2022
*****************************************************************************************/

@isTest
public with sharing class TestHandleSSO
{
    static testmethod void testCreate()
    {

        Profile p = [SELECT Id FROM Profile LIMIT 1];

        Map<String, String> attributes = new Map<String, String>();
        attributes.put('User.Username', 'test@test.com');
        attributes.put('User.LastName', 'Schmo');
        attributes.put('User.FirstName', 'Joe');
        attributes.put('User.Alias', 'jschm');
        attributes.put('User.FederationIdentifier', '5678');
        attributes.put('User.ProfileId', p.Id);
        attributes.put('User.Phone', '55555555555');
        attributes.put('User.Email', 'test@test.com');

        HandleSSO hsso = new HandleSSO();

        User usr = hsso.createUser(null, null, null, '5678', attributes,null);
    }

    static testmethod void testCreate2()
    {

        Profile p = [SELECT Id, Name FROM Profile where Name = 'Standard User'];

        Map<String, String> attributes = new Map<String, String>();
        attributes.put('User.Username', 'test@test.com');
        attributes.put('User.LastName', 'Schmo');
        attributes.put('User.FirstName', 'Joe');
        attributes.put('User.Alias', 'jschm');
        //attributes.put('User.FederationIdentifier', '5678');
        attributes.put('User.ProfileId', p.Name);
        attributes.put('User.Phone', '55555555555');
        attributes.put('User.Email', 'test@test.com');

        HandleSSO hsso = new HandleSSO();

        User usr = hsso.createUser(null, null, null, '5678', attributes,null);
    }

    static testmethod void testUpdate()
    {
        HandleSSO hsso = new HandleSSO();
        hsso.updateUser(null, null, null, null, null, null, null);
    }
}