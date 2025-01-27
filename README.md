[![Apache License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0) ![dbt logo and version](https://img.shields.io/static/v1?logo=dbt&label=dbt-version&message=1.x&color=orange)

# Athena Connector

## 🔗  Docs
Check out our [docs](https://thetuvaproject.com/) to learn about the Tuva Project and how you can use it with your healthcare data.
<br/><br/>

## 🧰  What does this repo do?
The Athena Connector is a dbt project that maps raw data from AthenaOne's warehouse to the Tuva Data Model and then builds all the clinical Tuva Data Marts.  It is built to work on both a single or multi tenant setup. 
<br/><br/>  

## 🔌 Database Support
- Snowflake
- BigQuery
<br/><br/>  

## ✅ Quickstart Guide

### Step 1: Pre-requisites
You must have medical record data from Athena in a data warehouse supported by this project.
<br/><br/> 

### Step 2: Configure Input Database and Schema
Configure the appropriate profile for the project in `dbt_project.yml`. Set the name of your Athena database and schema in `sources.yml`.  Set the name of your output database in your profile or `dbt_project.yml`.    
<br/><br/> 

### Step 4: dbt deps
Execute the command `dbt deps` to add the Tuva and dbt utils packages to your project.
<br/><br/>

### Step 4: Run
Now you're ready to run the connector and the Tuva Project. Run `dbt build` to run the full project; alternatively use dbt's [selection syntax](https://docs.getdbt.com/reference/node-selection/syntax) to run parts of the project or specific models, or use other [dbt commands](https://docs.getdbt.com/reference/dbt-commands) to utilize other dbt functionality.
<br/><br/>

## 🙋🏻‍♀️ How do I contribute?
Have an opinion on the mappings? Notice any bugs when installing and running the project?
If so, we highly encourage and welcome feedback!  Feel free to submit an issue or drop a message in Slack.
<br/><br/>

## 🤝 Join our community!
Join our growing community of healthcare data practitioners on [Slack](https://join.slack.com/t/thetuvaproject/shared_invite/zt-16iz61187-G522Mc2WGA2mHF57e0il0Q)!