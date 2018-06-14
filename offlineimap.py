# This fill fetch and decrypt password files and load them into Offline-iMap
import os
import subprocess
def mailpasswd(acct):
  acct = os.path.basename(acct)
  path = "/Users/gustafbrostedt/.passwrd/%s.gpg" % acct
  args = ["gpg", "--use-agent", "--quiet", "--batch", "-d", path]
  try:
    return subprocess.check_output(args).strip()
  except subprocess.CalledProcessError:
    return ""
# print(mailpasswd("gmail"))
