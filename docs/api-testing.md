# Migration Guides & Infrastructure Notes

##REST API, HTTP, JSON

### REST API
REST (Representational State Transfer) is an architectural style for building distributed systems. It focuses on stateless communication, resource-based URLs, and standardized HTTP methods.
- **Client–server**: Separation of concerns between UI and data storage
- **Stateless**: Each request contains all information needed to process it
- **Cacheable**: Responses must define themselves as cacheable or non-cacheable
- **Layered system**: Client cannot tell if connected directly to end server
- **Uniform interface**: Standardized way to interact with resources
- **Code on demand** (optional): Servers can extend client functionality

### “stateless”

### idempotent
GET

PUT

DELETE

HEAD

OPTIONS

TRACE


### POST vs PUT vs PATCH – differences

POST → Create a new resource; not idempotent.

PUT → Replace a resource entirely; idempotent.

PATCH → Partially update a resource; not necessarily idempotent.


### pagination
Common types:

Offset/Limit (?offset=0&limit=20)

Cursor-based (uses a token for stable pagination)

### What is HTTP
HTTP (Hypertext Transfer Protocol) is a protocol for transferring data over the internet. It is the foundation of the World Wide Web and is used to transfer data between a client and a server.

###HTTP methods
GET

POST

PUT

DELETE

HEAD

OPTIONS

TRACE

### HTTP status codes
1xx – Informational

2xx – Success

3xx – Redirection

4xx – Client errors

5xx – Server errors

200 OK

201 Created

204 No Content

400 Bad Request

401 Unauthorized

403 Forbidden

404 Not Found

500 Internal Server Error

###  Safe vs Idempotent methods

Safe: No state change (GET, HEAD)

Idempotent: State remains the same after repeated requests (PUT, DELETE)

### HTTPS

HTTP Secure (HTTPS) is a protocol for transferring data over the internet. It is the foundation of the World Wide Web and is used to transfer data between a client and a server.
HTTPS = HTTP + TLS encryption

Provides confidentiality, integrity, authentication

### JSON
JSON (JavaScript Object Notation) is a data-interchange format that is typically used to transmit data between a client and a server.
A lightweight data-interchange format using key-value pairs.

Supported data types:

Number

String

Boolean

Array

Object

Null

###  JSON vs XML

### JSON Schema
JSON Schema is a vocabulary that allows you to annotate and validate JSON documents.

### What do you test in an API
Status codes

Headers

Response body

Data types

Schemas

Business logic

Performance

Authorization & Authentication

Negative scenarios

Idempotency

###  How do you test an endpoint with side effects (e.g., POST creating data)

Create resource → verify 201

Fetch the resource → verify fields

Clean up → delete the resource

Retry POST with same payload → ensure non-idempotency behavior

### How do you test async operations (e.g., queues, callbacks)?

### API testing tools
Postman

### API testing frameworks






