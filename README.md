# Rails Engineer Test
We'll be using this test to assess your skill level as a Rails engineer. This test is designed to cover a wide variety of skills that are needed in the day-to-day job of a Rails engineer at [Beequip](https://www.beequip.nl/). We expect you to spend a maximum of four hours on this test. You can use Google and Stack Overflow, just like you would normally do. Don't worry when you run out of time though — we would still like to see what you came up with!
## Objectives and Requirements
Create a Rails web application that provides a search interface for companies with the following functional requirements:
Admins should have a page to import companies by uploading a CSV file (found at `config/data/companies.csv`)
Users should be presented with a search field when they visit the root
Users should be able to see search results using the name, city, or registry number of a company
Results should appear progressively (e.g., typing `Be` shows all companies with `Be` in their name, city, or CoC number)
You can use [KvK Search](https://www.kvk.nl/zoeken/) as inspiration.
### Technical Requirements
Companies have a unique CoC number; duplicates keep the *last* result
Search queries must use SQL (no Ruby in-memory filtering)
Public access only — no authentication or authorization
Use the preinstalled **Bootstrap** and **Stimulus** libraries
Prioritize functionality over design due to limited time
---
## Getting Started
Make sure your environment meets these versions:
```bash
ruby 3.1.4
rails 7.0.x
bundler 2.3.x
yarn 1.22.x
Setup
# Install dependencies
bin/bundle install
yarn install
# Setup database
bin/rails db:setup
# Import companies from CSV
bin/rails companies:import   # imports from config/data/companies.csv
# Run the server
bin/rails s
Now open:
	•	Main search page: http://localhost:3000
	•	Admin CSV import: http://localhost:3000/admin/companies/new

Implementation Details
Core Architecture
Layer	Responsibility	Key Files
Model	Validations, normalization, SQL search	app/models/company.rb
Service	CSV parsing and upsert (last entry wins)	app/services/company_importer.rb
Controller	Root search and admin import endpoints	app/controllers/companies_controller.rb, app/controllers/admin/companies_controller.rb
View	Turbo + Stimulus-based UI	app/views/companies/*, app/javascript/controllers/search_controller.js
Task	CLI import from CSV	lib/tasks/companies.rake

Design Summary
	•	Database-first: Enforces unique CoC numbers via DB index (index_companies_on_coc_number)
	•	Importer: CompanyImporter reads and upserts CSV rows (upsert_all)
	•	Search: SQL-only lookup using indexed lowercase columns (name_lc, city_lc)
	•	Controllers: Thin endpoints, single responsibility per action
	•	Frontend: Stimulus controller with 150 ms debounce for live results via Turbo Frames
	•	Tests: Model validation + SQL scope and a system test verifying progressive search behavior

Example Queries
"Bee"  → matches "Beequip" and "Bergen"
"123"  → finds companies with CoC numbers containing 123

Development and Testing
# Reset DB and reimport CSV
bin/rails db:reset
bin/rails companies:import
# Run tests
bin/rails test
bin/rails test:system

Notes
	•	All search logic executes in SQL — no Ruby filtering.
	•	Duplicate CoC entries are replaced by the latest CSV occurrence.
	•	CSV import is idempotent and uses upsert_all.
	•	UI updates progressively via Turbo + Stimulus.
	•	companies:import task can be re-run safely at any time.

Deliverables
Share a link to your hosted repository (GitHub, GitLab, etc.) with:
	•	Complete source code
	•	Instructions to run locally (as above)

Questions
If you have questions about the test, contact:
	•	Jan van der Pas — jan.vanderpas@beequip.nl
	•	Marthyn Olthof — marthyn.olthof@beequip.nl
