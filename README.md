# DogNetS
## Description
DogNetS is a social network for dog owners and their dogs. The purpose of our network is to help people find buddies for their dogs. 

## User Stories (Required) 
[x] User signup/login/logout  
[x] Create and edit user profiles  
[x] Creating multiple dog profiles  
[ ] Search and add pals for user's dog  
[ ] Sharing the user's dog activity (walks, playing at the park, etc)  

## User Stories (Optional) 
[ ] Notifications on dog pal's activities  
[ ] Send and receive messages  
[ ] Login using social networks/other sites (Facebook, Twitter, LinkedIn, Google, etc)	

## Data Schemas
- Users 
  - Name: String
  - Username: String
  - Password: String
  - Biography
  - Profile pic: PFile 
  - Dogs 
    - Profile pic: PFile
    - Name: String
    - Breed: String
    - Age (optional)
    - Description
    - List of Pals
