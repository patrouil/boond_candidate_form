# boond_candidate_form
A single web page receive job application and record a Boond Manager Candidate
## setup
Integrate this web page in your website.
For some hints read : https://flutter.dev/docs/deployment/web#building-the-app-for-release

In the assets/assets/cfg subdir create a file settings.json. Use sample-settings.json as a sample.

    "boond_host" : is your workspace hostname either ui or sandboxui.
    "users_token" : Is your workspace's user token key. 

API must be enabled for the Workspace.

    "client_key" :  Gives here the API Key of the user to be used for a Boond Session.
    "client_token" : Give the API token of the user to be used for the Boond Session.

    "email.hr" : If an error occurs when storing a user request in Boond sie, this email is shown the the user.
    "gdpr.message" : otionnally you can provide a GDPR question such as "I do allow company XXX to record my personnal data".
    "accept.message" : Give an acknowledgement message when the applciation is recorded.
