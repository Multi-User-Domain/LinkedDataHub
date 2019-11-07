#!/bin/bash

cd admin

printf "\n### Creating authorization to make the app public\n\n"

./make-public.sh "$@"

cd model

printf "\n### Adding schema.org import to domain ontology\n\n"

./add-imports.sh "$@"

printf "\n### Creating classes\n\n"

./create-classes.sh "$@"

cd ../sitemap

printf "\n### Creating template queries\n\n"

./create-queries.sh "$@"

printf "\n### Creating templates\n\n"

./create-templates.sh "$@"

cd ..

printf "\n### Clearing ontologies\n\n"

./clear-ontologies.sh "$@"

cd ..

printf "\n### Creating containers\n\n"

./create-containers.sh "$@"

printf "\n### Importing CSV data\n\n"

./import-csv.sh "$@"