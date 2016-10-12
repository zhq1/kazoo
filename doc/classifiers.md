Carriers
========

Each carrier should have A/B-number transformation rules (e.g. as regexes with substitution),
for incoming calls and for outgoing calls.

Classification
==============

Class is a name associated with one or more prefixes: {Name, [1, 1800, ...]}. Prefixes are ordered by
their length, more lengthly prefix is more specific. Each phone number could be classified by comparing with
class prefixes, and have zero or more classes associated with, ordered by matching length.

Access tables
==============

Access tables are named ordered tables of rules. Rules are in form of {Class, Action}, where Class is either a Class name,
or a prefix, and Action is either deny or allow. Tables are looked up from top to bottom until the first match. If no match
occures then default action is performed (either deny or allow). Access tables could be associated with account/user/device/carrier,
hierarchicaly and separately for inbound and outbound calls, and may or may not include references to other access tables.

Routing tables
==============

Routing tables are named ordered tables of rules. Rules are in form of {Class, Carrier}, where Class is either a Class name,
or a prefix, and Carrier is reference to a carrier (sip provider). Table lookup order and behaviour is determined by a strategy
(best match, lcr, etc). Default strategy is to match rules with number until call will be successfuly placed or no match will occur.
Each such routing table effectivly determines a virtual carrier, and could be associated with account/user/device, and may or may
not include references to other routing tables.

UI
==

An account administrator should be able to create, view and edit access tables and routing tables, including definition of classes
of numbers, and should be able to associate these tables within account with carrier/account/user/device.
While editing these tables an administrator should be able to change order of rows.
