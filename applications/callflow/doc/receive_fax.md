## Receive Fax

### About Receive Fax

Instructs the switch to receive a fax from the caller. Stores the fax in the database and optionally emails configured users.

#### Schema

Validator for the receive_fax callflow data object



Key | Description | Type | Default | Required | Support Level
--- | ----------- | ---- | ------- | -------- | -------------
`media.fax_option` | Caller flag for T38 settings | `string('auto' | 'false' | 'true') | boolean()` |   | `false` |  
`media` |   | `object()` |   | `false` |  
`owner_id` | User ID to send fax to | `string()` |   | `false` |  



