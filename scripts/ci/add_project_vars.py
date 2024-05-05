#!/usr/bin/env python3

import os
import requests
from dotenv import load_dotenv
import argparse

# Load the environment variables from the .env file
# can specify the path to load_dotenv() but is should recursively search for the .env file
load_dotenv()

gitlab_hostname = os.getenv("gitlab_hostname")
project_id = os.getenv("gitlab_project_id")
api_string = f"api/v4/projects/{project_id}/variables"
headers = {"PRIVATE-TOKEN": os.getenv("gitlab_access_token")}

url = f"https://{gitlab_hostname}/{api_string}"

def get_variables():
  r = requests.get(url, headers=headers, verify=False)
  return r.json()

def create_variables():
  """
  creates gitlab project variables from environment variables
  """
  for key, value in os.environ.items():
    if str(key).lower().startswith("gitlab"):
      print(f"Adding {key} to project variables")
      r = requests.post(url, headers=headers, data={"key": key, "value": value}, verify=False)
      if r.status_code == 201:
        print(f"Successfully added {key} to project variables")
      elif r.status_code == 400:
        print(f"{key} already exists in project variables")
        # update the variable
        r = requests.put(f"{url}/{key}", headers=headers, data={"value": value}, verify=False)
      else:
        print(f"{r.status_code}: Failed to add {key} to project variables")

def delete_variables():
  """
  deletes all gitlab project variables
  """
  print('Deleting project variables')
  variables = get_variables()
  for variable in variables:
    r = requests.delete(f"{url}/{variable['key']}", headers=headers, verify=False)
    if r.status_code == 204:
      print(f"Successfully deleted {variable['key']} from project variables")
    else:
      print(f"{r.status_code}: Failed to delete {variable['key']} from project variables")


if __name__ == "__main__":
  create_variables()