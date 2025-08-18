param (
    [string]$Message = "Auto commit"
)

git add .
git commit -m "$Message"
git push origin main

