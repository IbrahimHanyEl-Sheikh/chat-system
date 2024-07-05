[Demo.zip](https://github.com/user-attachments/files/16113447/Demo.zip)# Chat system using Ruby on rails

It allows creating new applications where each application can have multiple chats, and each chat contains multiple messages. 

## Table of contents:
* Demo
* Dependencies
* How to run 
* Versions used
* Endpoints
* Services (job queues, cache servers, search engines, etc.)

### Demo
[Demo.zip](https://github.com/user-attachments/files/16113446/Demo.zip)


### Dependencies
1. Docker
2. Docker Compose

### How to run
1. Clone the repo
2. Run docker-compose using the following command
```
docker-compose up
```
### Versions used
- **Ruby on rails:** 7.1.3
- **Ruby:** 3.3.3
- **Docker:** v27.0.3
- **Docker compose:** v1.25.0
- **Elasticsearch:** v7.8.1
- **Mysql:** latest 

### Endpoints
#### `ApplicationsController`

- **GET** `/applications` - Retrieves all applications.
- **GET** `/applications/:token` - Retrieves a specific application.
- **POST** `/applications` - Creates a new application.
- **PATCH/PUT** `/applications/:token` - Updates an existing application.

#### `ChatsController`

- **GET** `/chats` - Retrieves all chats within an app.
- **GET** `/chats/:number` - Retrieves a specific chat within an app.
- **POST** `/chats` - Creates a new chat within an app.

#### `MessagesController`

- **GET** `/messages` - Retrieves all messages within a chat.
- **GET** `/messages/:number` - Retrieves a specific message within a chat.
- **POST** `/messages` - Creates a new message within a chat.
- **PATCH/PUT** `/messages/:number` - Updates an existing message within a chat.
- **DELETE** `/messages/:number` - Deletes a message from a chat.
- **GET** `/messages/search?body=query_msg` - Searches messages by a query parameter within a chat.

### Services

1. Elasticsearch
2. MySQL
3. Redis
4. Redlock
5. Searchkick
6. Sidekiq
### Note
sometimes when trying to make search for the message show error that need to execute **Message.reindex** so needs to update the indexes in the elasticsearch to interact with it normally.
so open terminal and execute these commands.
```
docker exec -it chat-system-backend bundle exec rails console
Message:reindex
exit
```
