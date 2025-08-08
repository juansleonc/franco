# Entity: Property

## Fields
- id (UUID)
- code (string, unique, human-friendly)
- type (enum: house, apartment, office, warehouse, land)
- addressLine1 (string)
- addressLine2 (string, optional)
- city (string)
- state (string)
- country (string)
- ownerId (UUID)
- status (enum: available, rented, maintenance, inactive)
- features (json: rooms, bathrooms, areaM2, parkingSpots, furnished)

## Relationships
- belongsTo Owner
- hasMany Contracts
- hasMany Expenses

## Indexes
- unique(code)
- index(ownerId)

## Invariants
- code must be unique per portfolio
- status transitions must be validated against active contracts
