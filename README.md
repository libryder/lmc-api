Overview 
========

LogMyCalls provides a felexible and powerful API for users to programmatically manage their account. The endpoint for all methods is 

`https://api.logmycalls.com/services/methodName` 

All calls must be made over https using the post method. 

_____

Methods 
======= 

* __[insertCall][1]__ - Upload sound file and add it to the Listen page.

* __[insertUser][6]__ - Create user and assign it to an organization.

* __[insertGroup][7]__ - Create group and assign it to a parent organization.

* __[insertComment][9]__ - Insert comment for call detail record.

* __[insertTag][10]__ - Insert tag for call detail record.

* __[updateCallDetail][11]__ - Update data for a specific call detail.

* __[updateUser][12]__ - Update data for a specific call detail.

* __[updateGroup][13]__ - Update data for a specific call detail.

* __[getCallDetails][2]__ - Returns a single, or list of, call detail record(s) based on search criteria.

* __[getGroups][3]__ - Returns a single, or list of, groups within an organizational unit based on search criteria.

* __[getSubscriptionInfo][4]__ - Returns information about your subscription.

* __[getUsers][5]__ - Returns a single, or list of, users within a group or ogranization based on search criteria.

* __[deleteRecord][8]__ - Deletes record from account. 

------------- 

insertCall 
----------

__Description__: Upload sound file and add it to the Listen page. 

###Arguments

> __api_key__ (required)

> __file__ (required) 
The file to upload. Acceptible file formats: mp3, wav (gsm, pcm)

> __call_date__ (required) 
Time the call started. Format: YYYY-MM-DD HH:MM:SS. 
example: 2011-08-24 00:00:00

> __ouid__ (required) 
ID of the organizational unit to assign call to. This can be viewed at 
http://logmycalls.com/api or you can use the API to make a call to the getGroups method

> __caller_id__ (optional)

> __tracking_number__ (optional) 
The tracking number to assign this call to. Note: if the tracking number you specify already 
belongs to an organization you do not have access to, an error will be returned. If a tracking number isn't specified it will be sortable as "Uploaded" in the "filter by" widget. 
Format: 12223334444.

> __ringto_number__ (optional) 
The number that was called. 
Format: 12223334444 

> __external_id__ (optional) 
The foreign key that links the record to your database. This is useful when you want to search using our 
api using the id of the record in your database.

> __call_type__ (optional) 
Specify whether the call was inbound or outbound.

> __assign_to__ (optional) 
The email address of the user to assign this call to. 
Format: user@domain.com 

###Example Response 

If the upload and insertion was successful, the following json is returned: 
`{"status": "success", "call_detail_id": "56342"}` 

If the upload was unsuccessful, the following json is returned: 
`{"status": "error", "error_message": "Wrong file format"}` 

-----------------

insertUser 
----------

__Description__: Insert a user into the designated organization. 

###Arguments

> __api_key__ (requrired)

> __email__ (required) 
Email address (username) of user to create. Must be unique.

> __first_name__ (required) 
First name of user to create.

> __last_name__ (required) 
Last name of user to create.

> __ouid__ (required) 
Organizational unit user belongs to. 

> __external_id__ (optional) 
The foreign key that links the record to your database. This is useful when you want to search using our 
api using the id of the record in your database. Must be unique to your company.

###Example Response 

If user creation was successful, the following json is returned: 
`{"status": "success", "user_id": "453"}` 

If creation was unsuccessful, the following json is returned (as an example): 
`{"status": "error", "error_message": "Email address exists."}` 

----------------- 

insertGroup 
---------------

__Description__: Insert a group as a child of an organization.

###Arguments

> __api_key__ (requrired)

> __parent_ouid__ (required) 
Parent ID of the organization to create under.

> __name__ (optional) 
The name of the organizational unit. Can specify partial names to return an array of results matching that string.

> __address_line_1__ (optional) 
Address organization is in. Not required for non-physical locations.

> __address_line_2__ (optional) 
Address organization is in. Not required for non-physical locations.

> __state__ (optional) 
State organization is in. Not required for non-physical locations.

> __zip__ (optional) 
Zipcode organization is in. Not required for non-physical locations.

> __external_id__ (optional) 
The foreign key that links the record to your database. This is useful when you want to search using our 
api using the id of the record in your database. Must be unique to your company.

###Example Response 

If group creation was successful, the following json is returned: 
`{"status": "success", "group_id": "45"}` 

If creation was unsuccessful, the following json is returned (as an example): 
`{"status": "error", "error_message": "External ID already exists."}` 

-------

insertComment 
----------

__Description__: Add comment to speficied call detail. 

###Arguments

> __api_key__ (required)

> __user_id__ (required) 
ID of user to assign comment to.

> __call_detail_id__ (required) 
ID of call detail to assign comment to.

> __is_public__ (optional) 
Determines if comment can be seen by entire organization or only by user comment is assigned to. Default 
is public.

> __comment__ (required) 
Comment to insert.

-----------------

insertTag 
----------

__Description__: Add tag to speficied call detail. 

###Arguments

> __api_key__ (required)

> __user_id__ (optional) 
ID of user to assign tag to. Required if is_public is set to 0.

> __call_detail_id__ (required) 
ID of call detail to assign comment to.

> __is_public__ (optional) 
Determines if tag can be seen by entire organization or only by user tag is assigned to. Default 
is public.

> __tag__ (required) 
Tag to insert.

----------

updateCallDetail 
----------

__Description__: Update information about a call detail. 

###Arguments

> __api_key__ (required)

> __id__ (optional) 
ID of the call detail to update. If this id is not specified an external_id __must__ be specified.

> __call_date__ (optional) 
Time the call started. Format: YYYY-MM-DD HH:MM:SS. 
example: 2011-08-24 00:00:00

> __ouid__ (optional) 
ID of the organizational unit to reassign call to.

> __caller_id__ (optional)

> __tracking_number__ (optional) 
The tracking number to reassign this call to. Note: if the tracking number you specify already 
belongs to an organization you do not have access to, an error will be returned. If a tracking number isn't specified it will be sortable as "Uploaded" in the "filter by" widget. 
Format: 12223334444.

> __ringto_number__ (optional) 
The number that was called. 
Format: 12223334444 

> __external_id__ (optional) 
The foreign key that links the record to your database. This is useful when you want to search using our 
api using the id of the record in your database.

> __call_type__ (optional) 
Specify whether the call was inbound or outbound.

> __assign_to__ (optional) 
The email address of the user to assign this call to. 
Format: user@domain.com 

###Example Response 

If the update was successful, the following json is returned: 
`{"status": "success", "call_detail_id": "56342"}` 

If the update was unsuccessful, the following json is returned: 
`{"status": "error", "error_message": "Wrong file format"}`

-------------

updateUser 
----------

__Description__: Update a specific user by id. 

###Arguments

> __api_key__ (requrired)

> __id__ (optional) 
ID of user to update. If this field is not specified, external_id __must__ be specified or the update will fail.

> __email__ (optional) 
Email address (username) of user to update. Must be unique.

> __first_name__ (optional) 
First name of user to update.

> __last_name__ (optional) 
Last name of user to update.

> __ouid__ (optional) 
Organizational unit user belongs to. 

> __external_id__ (optional) 
The foreign key that links the record to your database. Must be unique to all users within your company.

###Example Response 

If user update was successful, the following json is returned: 
`{"status": "success", "user_id": "453"}` 

If creation was unsuccessful, the following json is returned (as an example): 
`{"status": "error", "error_message": "Email address exists."}`

--------

updateGroup 
---------------

__Description__: Update a group in your company by id.

###Arguments

> __api_key__ (requrired)

> __id__ (optional) 
ID of group to update. If this field is not specified, external_id __must__ be specified or update will fail.

> __name__ (optional) 
The name of the organizational unit.

> __address_line_1__ (optional) 
Address organization is in. Not required for non-physical locations.

> __address_line_2__ (optional) 
Address organization is in. Not required for non-physical locations.

> __state__ (optional) 
State organization is in. Not required for non-physical locations.

> __zip__ (optional) 
Zipcode organization is in. Not required for non-physical locations.

> __external_id__ (optional) 
The foreign key that links the record to your database. Must be unique to all groups within your company.

###Example Response 

If group update was successful, the following json is returned: 
`{"status": "success", "group_id": "45"}` 

If creation was unsuccessful, the following json is returned (as an example): 
`{"status": "error", "error_message": "External ID already exists."}` 

-------

getCallDetails 
---------------

__Description__: Returns a single, or list of, call detail record(s) based on passed criteria.

###Arguments

> __api_key__ (requrired)

> __ouid__ (required) 
The id of the organization the call belongs to.

> __id__ (optional) 
The id of the call detail. Will return a single call detail or "not found".

> __tracking_number__ (optional) 
The tracking number the call was assigned to. If you only want to see calls that were uploaded, specify "uploaded" as the tracking number. 
A minimum of 3 and maximum of 11 digits is required.

> __ringto_number__ (optional) 
The number that was called. 
A minimum of 3 and maximum of 11 digits is required.

> __start__ (optional) 
The nth record to start from. For example, specifying "30" would get results starting at the 30th result

> __limit__ (optional)

> __sort_by__ (optional) 
The field to sort by. Options: id, tracking_number, ringto_number

> __sort_order__ (optional) 
What order to sort results by. Options: desc, asc

> __external_id__ (optional)

###Example Response 

[ 
"status": "success", 
"matches": "1", 
"results": 
{ 
"id": "56342", 
"call_date": "2011-08-24 00:00:00", 
"tracking_number": "12223334444", 
"ringto_number": "12223334444", 
"caller_id":	"12223334444", 
"direction": "inbound", 
"duration": "127", 
"file_url": "http://www.logmycalls.com/recordings/somesound.mp3", 
"status": "active", 
"external_id": "5" 
} 
]

The "results" response will always represent an array, even if only one result is returned. Results will return a 
maximum of 100 results.

----------------

getGroups 
---------------

__Description__: Returns a single, or list of, groups within an organizational unit based on search criteria.

###Arguments

> __api_key__ (requrired)

> __ouid__ (required) 
The id of the organization to search in.

> __id__ (optional) 
The id of the group. Will return a single group or "not found".

> __name__ (optional) 
The name of the organizational unit. Can specify partial names to return an array of results matching that string.

> __state__ (optional) 
State organization is in. Format: CA

> __zip__ (optional) 
Zipcode group is in. Format: 92136

> __start__ (optional) 
The nth record to start from. For example, specifying "30" would get results starting at the 30th result

> __limit__ (optional)

> __stores_only__ (optional) 
Search only for groups which have been marked as a Store in Users/Groups setup page. Options: true, false

> __sort_by__ (optional) 
The field to sort by. Options: id, name, state, zip

> __sort_order__ (optional) 
What order to sort results by. Options: desc, asc

> __external_id__ (optional)

###Example Response 

[ 
"status": "success", 
"matches": "1", 
"results": 
{ 
"id": "56342", 
"parent_id": "34", 
"name": "Bob's Fat Tacos", 
"address_line_1": "125 Main St", 
"address_line_2": "Suite 102", 
"city": "San Diego", 
"state": "CA", 
"zip": "92136", 
"is_store": "true", 
"latitude": "32.6822", 
"longitude": "-117.1094", 
"phone_number": "6192547848", 
"status": "active" 
} 
]

The "results" response will always represent an array, even if only one result is returned. Results will return a 
maximum of 50 results.

---------

getSubscriptionInfo 
---------------

__Description__: Returns information about your subscription.

###Arguments

> __api_key__ (requrired)

###Example Response

[ 
"status": "success", 
"results": 
{ 
"parent_id": "34", 
"name": "Bob's Fat Tacos", 
"address_line_1": "125 Main St", 
"address_line_2": "Suite 102", 
"city": "San Diego", 
"state": "CA", 
"zip": "92136", 
"is_store": "true", 
"latitude": "32.6822", 
"longitude": "-117.1094", 
"phone_number": "6192547848", 
} 
]

---------- 

getUsers 
---------------

__Description__: Returns a single, or list of, users within an organizational unit based on search criteria.

###Arguments

> __api_key__ (requrired)

> __email__ (optional) 
Email address (username) of user to search for. Can be a partial string.

> __first_name__ (optional) 
First name of user to search for. Can be a partial string.

> __last_name__ 
Last name of user to search for. Can be a partial string.

> __group_id__ (optional) 
ID of group user is currently assigned to.

> __ouid__ (optional) 
Organizational unit user belongs to.

> __start__ (optional) 
The nth record to start from. For example, specifying "30" would get results starting at the 30th result

> __limit__ (optional) 
How many records to return. Maximum of 100.

> __sort_by__ (optional) 
The field to sort by. Options: id, first_name, last_name, group_id

> __sort_order__ (optional) 
What order to sort results by. Options: desc, asc

###Example Response

[ 
"status": "success", 
"results": 
{ 
"username": "user@yoohoo.com", 
"first_name": "John", 
"last_name": "Smith", 
"group_id": "5", 
"ouid": "32.6822", 
"status": "active", 
"created": "2010-12-14 10:24:02", 
} 
] 

----------

deleteRecord 
---------------

__Description__: Returns a single, or list of, users within an organizational unit based on search criteria.

###Arguments

> __api_key__ (requrired)

> __type__ (required) 
Record type to delete. Options: tag, comment, group, user. If a group has children groups, delete will not succeed.

> __id__ (required) 
ID of object to delete

> __ouid__ (required) 
ID of organization

[1]: #insertCall 
[2]: #getCallDetails 
[3]: #getGroups 
[4]: #getSubscriptionInfo 
[5]: #getUsers 
[6]: #insertUser 
[7]: #insertGroup 
[9]: #insertComment 
[10]: #insertTag 
[8]: #deleteRecord 
[11]: #updateCallDetail 
[12]: #updateUser 
[13]: #updateGroup


