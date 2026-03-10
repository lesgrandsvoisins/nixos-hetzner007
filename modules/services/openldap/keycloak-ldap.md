## Keyclaok LDAP User federation

| Keycloak field | LDAP attribute |
| --- | --- |
| Username | `uid` |
| Email | `mainMail` |
| First name | `givenName` |
| Last name | `sn` |
| UUID attribute | `entryUUID` |

### Keycloak Event Listener

User registers → create:

uid=alice,ou=users

Then automatically create:

gvMail=alice@gv.je,ou=gvMail

Set:

mainMail: [alice@gv.je](mailto:alice@gv.je)

## Links

Add links such as:

Email Administration  
Member Portal  
Documentation

inside:

account.ftl

Keycloak supports this directly.

## Postfix

Mailbox lookup:

(base=ou=gvMail,dc=gv,dc=je)  
(filter=(gvMail=%s))  
(result=gvMail)

Forward lookup:

(filter=(&(gvMail=%s)(gvForward=\*)))

User lookup for auth:

(filter=(gvMail=%u))

## Mailbox Object

Structural object.

dn: gvMail=alice@gv.je,ou=accounts,ou=mail,dc=gv,dc=je  
objectClass: gvMailAccount

gvMail: alice@gv.je  
gvUserDN: uid=alice,ou=users,dc=gv,dc=je  
gvDomain: gv.je

gvSendEnabled: TRUE  
gvReceiveEnabled: TRUE

gvIMAP: TRUE  
gvPOP3: FALSE

gvQuota: 2147483648

Important attributes:

attribute purpose  
gvMail mailbox address  
gvUserDN owner  
gvQuota mailbox quota  
gvSendEnabled SMTP sending allowed  
gvReceiveEnabled SMTP receiving allowed  
gvIMAP IMAP access  
gvPOP3 POP3 access

## Alias Object

Aliases are separate objects.

This is critical because:

one alias may target multiple mailboxes

aliases may forward externally

aliases may change independently

Example:

dn: gvAlias=sales@gv.je,ou=aliases,ou=mail,dc=gv,dc=je  
objectClass: gvMailAlias

gvAlias: sales@gv.je  
gvAliasTarget: alice@gv.je  
gvAliasTarget: bob@gv.je

Aliases can forward to:

internal mailbox

external email

multiple recipients

### Prompt

generate the schema for

gvUserAccount auxilliary class to inetOrgPerson with mainMail  
gvMailbox structural class with gvMail, gvUserDN, gvMailQuota, gvSMTPSend, gvSMTPRecieve, gvIMAP, gvPOP3  
gvMailAlias structural class with gvMailboxDN, gvMail, gvMailForward  
gvMailDomain structural class with domainName

to each class add an auxilliary class "disvalidated" with , disabled (boolean), validated (boolean)

top level is dc=lesgrandsvoisins, dc=com

admin is cn=admin, dc=lesgrandsvoisins,dc=com

create a new group cn=gvadmin, ou=groups,  dc=lesgrandsvoisins,dc=com

groups are in ou=groups,  dc=lesgrandsvoisins,dc=com

keycloak maps groups

there is a newusers group

groupOfUniqueNames map to DNs in ou=users,dc=lesgrandsvoisins,dc=com

gvadmin group cand modify disvalidated attributes

users can add, delete modify gvMailbox, gvMailAlias owned by themselves

gvadmin can adminsitrate the whole

## ChatGPT Precos

Good — let’s extend your design into a **complete but still clean mail directory model** that scales well and fits **OpenLDAP + Postfix + Dovecot + Keycloak**.

The key idea is to separate **four concerns**:

**Identity** → users (`gvUserAccount`)

**Mailbox hosting** → mailboxes (`gvMailAccount`)

**Routing/aliases** → alias addresses (`gvMailAlias`)

**Domains** → mail domains (`gvDomain`)

This is the same conceptual separation used in large virtual-mail systems.

## 1\. Directory Layout

dc=gv,dc=je  
│  
├── ou=users  
│   └── uid=alice  
│  
├── ou=mail  
│   ├── ou=accounts  
│   │     └── gvMail=alice@gv.je  
│   │  
│   └── ou=aliases  
│         └── gvAlias=sales@gv.je  
│  
└── ou=domains  
      └── gvDomain=gv.je

Benefits:

Postfix queries **mail objects only**

Keycloak queries **users only**

domain policies are centralized

## 2\. Domain Object

Domains allow:

enabling/disabling domains

default quotas

domain routing

Example:

dn: gvDomain=gv.je,ou=domains,dc=gv,dc=je  
objectClass: gvDomain

gvDomain: gv.je  
gvDomainEnabled: TRUE  
gvDefaultQuota: 2147483648

## 3\. Mailbox Object

Structural object.

dn: gvMail=alice@gv.je,ou=accounts,ou=mail,dc=gv,dc=je  
objectClass: gvMailAccount

gvMail: alice@gv.je  
gvUserDN: uid=alice,ou=users,dc=gv,dc=je  
gvDomain: gv.je

gvSendEnabled: TRUE  
gvReceiveEnabled: TRUE

gvIMAP: TRUE  
gvPOP3: FALSE

gvQuota: 2147483648

Important attributes:

| attribute | purpose |
| --- | --- |
| gvMail | mailbox address |
| gvUserDN | owner |
| gvQuota | mailbox quota |
| gvSendEnabled | SMTP sending allowed |
| gvReceiveEnabled | SMTP receiving allowed |
| gvIMAP | IMAP access |
| gvPOP3 | POP3 access |

## 4\. Alias Object

Aliases are **separate objects**.

This is critical because:

one alias may target multiple mailboxes

aliases may forward externally

aliases may change independently

Example:

dn: gvAlias=sales@gv.je,ou=aliases,ou=mail,dc=gv,dc=je  
objectClass: gvMailAlias

gvAlias: sales@gv.je  
gvAliasTarget: alice@gv.je  
gvAliasTarget: bob@gv.je

Aliases can forward to:

internal mailbox

external email

multiple recipients

## 5\. User Object

dn: uid=alice,ou=users,dc=gv,dc=je  
objectClass: inetOrgPerson  
objectClass: gvUserAccount

uid: alice  
givenName: Alice  
sn: Example  
cn: Alice Example

mainMail: alice@gv.je

Used by:

Keycloak

LDAP directory

identity services

## 6\. Why Mailboxes Are Separate

Advantages:

### multiple mailboxes per user

alice@gv.je  
alice@company.gv.je  
support@gv.je

### shared mailboxes

info@gv.je → owned by service account

### service mailboxes

backup@gv.je  
monitoring@gv.je

None of those belong naturally on the person entry.

## 7\. Postfix LDAP Queries

Mailbox lookup:

base=ou=accounts,ou=mail,dc=gv,dc=je  
filter=(gvMail=%s)  
result=gvMail

Alias lookup:

base=ou=aliases,ou=mail,dc=gv,dc=je  
filter=(gvAlias=%s)  
result=gvAliasTarget

Domain lookup:

base=ou=domains,dc=gv,dc=je  
filter=(gvDomain=%d)

## 8\. Dovecot Lookup

Dovecot typically queries mailbox objects.

Example:

base=ou=accounts,ou=mail,dc=gv,dc=je  
filter=(gvMail=%u)

Return:

home=/mail/%d/%n  
quota\_rule=\*:storage=%{ldap:gvQuota}

## 9\. OpenLDAP Uniqueness Rules

Use **slapo-unique**.

Example:

olcUniqueURI: ldap:///ou=users,dc=gv,dc=je?mainMail?sub  
olcUniqueURI: ldap:///ou=accounts,ou=mail,dc=gv,dc=je?gvMail?sub  
olcUniqueURI: ldap:///ou=aliases,ou=mail,dc=gv,dc=je?gvAlias?sub

Ensures:

no duplicate mailbox

no duplicate alias

no duplicate primary mail

## 10\. ACL Example

Mailbox preferences self-service:

access to attrs=gvForward,gvSendEnabled,gvIMAP,gvPOP3  
    by dnattr=gvUserDN write  
    by \* read

User cannot modify:

gvMail  
gvDomain  
gvQuota

Those remain admin-only.

## 11\. Keycloak Federation

Keycloak LDAP settings:

| field | LDAP attribute |
| --- | --- |
| username | uid |
| email | mainMail |
| first name | givenName |
| last name | sn |
| UUID | entryUUID |

Keycloak reads only from **ou=users**.

Mail system reads only from **ou=mail**.

Clean separation.

## 12\. Username Generation UX

You wanted:

uid = first 4 letters of last name  
      + first 4 letters of first name

Example:

Alice Example → examalic

Implement as:

Keycloak **theme JS suggestion**

user may edit

Required attributes enforced via **Keycloak Declarative User Profile**.

## 13\. Keycloak Account UI Extension

Use **custom account theme**.

Add links such as:

Email settings  
Mailbox forwarding  
Member dashboard  
Documentation

Edit:

themes/\<your-theme>/account/account.ftl

Add:

\<a href="https://mail.gv.je/settings">  
Email Administration  
\</a>

## 14\. Full System Architecture

Keycloak  
   │  
   │ LDAP federation  
   ▼  
OpenLDAP  
   │  
   ├── Users  
   │      gvUserAccount  
   │  
   ├── Mailboxes  
   │      gvMailAccount  
   │  
   ├── Aliases  
   │      gvMailAlias  
   │  
   └── Domains  
          gvDomain

Postfix  
   │  
   └── LDAP queries

Dovecot  
   │  
   └── LDAP userdb

## 15\. Scalability

This model scales very well.

Large installations run **tens of millions of mailboxes** using almost this exact LDAP design.

Because:

mailbox lookups are fast

identity and mail data separated

aliases independent objects

domain policies centralized