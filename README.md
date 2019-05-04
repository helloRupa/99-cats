# 99 Cats
A Ruby Rails project for renting cats, similar to 99 dresses.
Visit: https://mighty-plateau-78555.herokuapp.com/cats

## Registration and Login
Users are required to register and login to access all website features. Each user must have a unique password. Passwords are stored in encrypted form. Only one login (a single session) is currently allowed per user.

## Add a Cat
Logged-in users may add a cat. Currently, a default image link is added to the database on create rather than allowing users to set their own images.

## Update a Cat
A user who creates a cat may edit that cat's details. Other users may not.

## Rent a Cat
Any logged-in user may rent a cat. If the request date conflicts with an existing approved request for that cat, the request will not be submitted.

## Approval and Denial of Requests
A cat's owner may approve or deny any rental requests for their cats. If a pending request overlaps a request that is approved, the other pending request will be denied.

## Deny Expired Requests
CatRentalRequest::cancel_expired_requests can be automated and run daily to deny any pending requests with a start date before the current date. Right now, it must be called manually, since automated requests contribute to using up the Heroku quota.
