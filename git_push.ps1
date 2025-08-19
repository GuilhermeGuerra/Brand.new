param (
    [string]$Message = " - New updates"
)

git add .
git commit -m "$Message"
git push origin main

