import webbrowser
import getpass

user = getpass.getuser()

def mailto(recipients, subject, body):
    webbrowser.open("mailto:%s?subject=%s&body=%s" % (recipients, str(subject), str(body)))

body_template = """What seems to be the problem?"""

def gen(email):
    mailto(email, "Revit Support - " + str(user), body_template)

gen("revithelp@archnexus.com")
