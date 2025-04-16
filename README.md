[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![dbt logo and version](https://img.shields.io/static/v1?logo=dbt&label=dbt-version&message=1.x&color=orange)

# Athena EMR dbt Connector

## 🔗 Docs
Check out our [docs](https://thetuvaproject.com/) to learn about the project and how you can use it.
<br/><br/>

## 🧰 What does this repo do?

**Welcome!** The Athenahealth Connector is a dbt project that maps raw Athena Electronic Medical Record (EMR) to the Tuva Input Layer, which is the first step in running The Tuva Project. Ultimately, this connector will help you transform your data into a structured, analytics-ready format using the power of dbt and the Tuva Project's healthcare data models.

We can think of this project as a specialized pipeline:
1.  **Input:** Raw data from your specific Athena EMR instance, located in your  data warehouse.
2.  **Process:** Uses **dbt (data build tool)** to clean, transform, and model this raw data. dbt allows us to write data transformations as simple SQL `SELECT` statements and handles the complexities of dependency management, testing, and documentation.
3.  **Framework:** Leverages **The Tuva Project**, an open-source project providing standardized data models specifically for healthcare data. This ensures your data is structured consistently and compatibly with best practices.
4.  **Output:** Creates well-defined tables (data marts) in your data warehouse, ready for analysis, reporting, and downstream use. These tables follow the Tuva Project's clinical data model structure.

## 🔌 Database Support
- Snowflake
- BigQuery
<br/><br/>

---
## Project Structure
* **dbt Models:** SQL files (`.sql`) in the `models/` directory that define the transformations from raw Athena data to staging, intermediate, and final Tuva Mart tables.
    * `models/staging`: Basic cleaning and renaming of raw Athena tables (materialized as views in the `athena_staging` schema).
    * `models/intermediate`: More complex joins and logic to prepare data for the final marts (materialized as tables in the `athena_intermediate` schema).
    * Final Mart Models: Building the standardized Tuva Marts.
* **Configuration Files:**
    * `dbt_project.yml`: Main configuration for this dbt project (name, version, model paths, schema configurations, variables).
    * `packages.yml`: Declares the external dbt packages needed (The Tuva Project, dbt_utils).
    * `sources.yml` (Located in `models/staging/`): You will configure this to tell dbt where your raw Athena data lives in your data warehouse.
* **Tests:** Data quality tests (`.yml` files) to help ensure the transformations are working correctly. This also checks the quality on input data. 

---

## ✅ Quickstart Guide

### **Step 1: Prerequisites**

Before you begin, ensure you have the following:

1.  **Access to your data warehouse:** Credentials and network access to your data warehouse instance (e.g. Snowflake, BigQuery).
2.  **Athena EMR Data:** Your raw Athena data must be loaded into specific tables within your data warehouse.
3.  **dbt CLI Installed:** You need dbt (version 1.9 recommended) installed on your machine or environment where you'll run the transformations. See [dbt Installation Guide](https://docs.getdbt.com/docs/installation) for help with installation.
4.  **Git:** You need Git installed to clone this project repository.
5.  **Authentication Details:** (A Snowflake-specific example follows)
    * Your Snowflake `account` identifier.
    * Your Snowflake `user` designated for dbt.
    * The `private_key.pem` file provided for JWT authentication.
    * The `passphrase` for the private key file (if it's encrypted). **Keep this secure!**

### **Step 2: Clone the Repository**

Open your terminal or command prompt and clone this project:

```bash
git clone https://github.com/tuva-health/athenahealth_connector.git
cd athenahealth_connector
```

## **Step 3: Create and Activate Virtual Environment**

It's highly recommended to use a Python virtual environment to manage project dependencies. This isolates the project's packages from your global Python installation.

1. Create the virtual environment (run this inside the athenahealth_connector directory):

```bash
# Use python3 if python defaults to Python 2
python -m venv venv
```
This creates a venv directory within your project folder.

2. Activate the virtual environment:
* macOS / Linux (bash/zsh):
```source venv/bin/activate```
* Windows (Command Prompt):
```venv\Scripts\activate.bat```
* Windows (PowerShell):
```.\venv\Scripts\Activate.ps1```
* Windows (Git Bash):
```source venv/Scripts/activate```

You should see (venv) prepended to your command prompt, indicating the environment is active.

## **Step 4: Install Python Dependencies** 

With the virtual environment active, install the required Python packages, including dbt and the warehouse-specific dbt adapter (e.g. `dbt-snowflake`, `dbt-bigquery`).

### **Step 5: Configure profiles.yml for Data Warehouse Connection**

dbt needs to know how to connect to your data warehouse. In general, this is done via a profiles.yml file, which you need to create. This file should NOT be committed to Git, as it contains sensitive credentials.

* **Location:** By default, dbt looks for this file in ~/.dbt/profiles.yml (your user home directory, in a hidden .dbt folder).
* **Content:** For a Snowflake-specific JWT token example, you would create the file with the following structure, replacing placeholders with your specific details. For other connection and data warehouse types, the specific structure of the profiles.yml may differ. For more information, see the [dbt docs](https://docs.getdbt.com/docs/core/connect-data-platform/profiles.yml).

```YAML

# This is the content for ~/.dbt/profiles.yml

default: # This name MUST match the 'profile:' setting in dbt_project.yml
  target: dev # Specifies which target environment configuration to use by default (e.g., 'dev')
  outputs:
    dev: # Name of your development target environment (you can name it differently)
      type: snowflake
      account: YOUR_SNOWFLAKE_ACCOUNT_IDENTIFIER # e.g., xy12345.us-east-1

      # --- User/Role ---
      user: YOUR_DBT_SNOWFLAKE_USERNAME          # The user dbt will connect as
      role: YOUR_DBT_SNOWFLAKE_ROLE              # The default role dbt will use

      # --- Warehouse ---
      warehouse: YOUR_DBT_SNOWFLAKE_WAREHOUSE    # The warehouse dbt will use

      # --- Database & Schema (Default target location for dbt models) ---
      # These define where dbt will CREATE new tables/views by default if not specified elsewhere
      database: YOUR_TARGET_DATABASE             # e.g., TUVA_OUTPUT_DEV
      schema: YOUR_TARGET_SCHEMA                 # e.g., DBT_USERNAME or ATHENA_TRANSFORMED

      # --- JWT Authentication ---
      authenticator: SNOWFLAKE_JWT
      private_key_path: /path/to/your/rsa_key.pem  # <<<--- IMPORTANT: Full path to your private key file
      private_key_passphrase: YOUR_KEY_PASSPHRASE  # <<<--- IMPORTANT: Password for the key file (if it has one)

      # --- Optional Settings ---
      threads: 4                                 # Number of parallel jobs dbt can run
      client_session_keep_alive: False           # Keep session alive for long queries (optional)
      query_tag: dbt_athena_connector_run        # Tag queries in Snowflake (optional)

    # You can add other targets here later, e.g., for production ('prod')
    # prod:
    #   type: snowflake
    #   account: ...
    #   ... (similar configuration, potentially different user/db/schema)
```
* **Security:** Ensure the private_key_path is correct and that the file permissions are secure. Treat the key file and passphrase like passwords.

### **Step 6: Install dbt Package Dependencies**

This project relies on external dbt packages (The Tuva Project and dbt_utils). Run the following command in your terminal from the project directory (the one containing dbt_project.yml):
```Bash
dbt deps
```
This command reads packages.yml and downloads the necessary code into the dbt_packages/ directory within your project.

### **Step 7: Test the Connection**

Before running transformations, verify that dbt can connect to Snowflake using your profiles.yml settings:
```Bash
dbt debug
```

Look for "Connection test: OK connection ok". If you see errors, double-check your profiles.yml settings (account, user, role, warehouse, authentication details, paths).

## Running the Project
Once setup is complete, you can run the dbt transformations:

Full Run (Recommended First Time), this command will:
* Run all models (.sql files in models/).
* Run all tests (.yml, .sql files in tests/).
* Materialize tables/views in your target data warehouse as configured.

```bash
dbt build
```

This might take some time depending on the data volume and warehouse size.

#### Run Only Models:
If you only want to execute the transformations without running tests:
```bash
dbt run
```

#### Run Only Tests:
To execute only the data quality tests:
```Bash
dbt test
```

#### Running Specific Models:
You can run specific parts of the project using dbt's node selection syntax. For example:
* Run only the staging models: `dbt run -s path:models/staging`
* Run a specific model and its upstream dependencies: `dbt run -s +your_model_name`

## Key Configuration (dbt_project.yml)

This file controls the core behavior of your dbt project:

* name: 'athena_connector': The internal name dbt uses for this project.
* profile: default: Tells dbt to look for the connection profile named default in your profiles.yml.
* models: section: Configures default settings for models. Here, it sets:
    Staging models (athena_connector.staging): To be created as views in the athena_staging schema in your target database.
    Intermediate models (athena_connector.intermediate): To be created as tables in the athena_intermediate schema in your target database.
* vars: section: Defines variables used within the project.
    clinical_enabled: true: This likely activates the Tuva clinical data mart models.
    tuva_last_run: Used internally by Tuva models to track run times.
* model-paths, test-paths, etc.: Define where dbt looks for different file types.

## Need Help?
* For general questions about dbt: Check the [dbt Documentation](https://docs.getdbt.com/).
* For general questions about the Tuva Project: Explore the [Tuva Project Docs](https://thetuvaproject.com/) or join Tuva [community Slack](https://join.slack.com/t/thetuvaproject/shared_invite/zt-16iz61187-G522Mc2WGA2mHF57e0il0Q).
