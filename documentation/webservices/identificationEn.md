# Identification for web services

## general principle

Except for the consultation of public collections, direct calls to the software without going through the graphical interface require the identification of the user (or the application). This identification is based on the use of a cryptographic token generated by the application.

In practice, a dedicated user is created in the database. This user is given a *token* which must be provided at the time of each request, at the same time as his login.

The user will then be positioned in a group, in the rights management, to be able to retrieve the access rights to the considered modules.

## Create an account

In the menu *Administration*, *List of local accounts*, create a new login:

- indicate the login used, for example the name of the application that will have access to the web services;
- click on *Account used for web service*
- do not enter a password
- validate: the account is created.

Go back to the account modification: the *Web service identification token* zone is now filled in. You can copy the token in the clipboard to use it in the calling application.

## Give the rights to the account

The account will be managed like the other accounts in the application: it must be placed in the appropriate groups so that it can get the access rights to the different modules.

The assignment is done from the menu *Administration > ACL - logins groups*, in the same way as for the classic users.

## Limitations

The use of tokens is incompatible if the identification mode defined in the software is set to **HEADER** and uses the *Mellon* mode of Apache (case of identification *via* the Renater identity federation, for example). Indeed, the *Mellon* mode manages the access before the user can call the application, which does not allow to analyze the token provided.

If you have set up this type of identification, and if you need to provide access to web services, whether the collections are public or not, then you will need to have a second address and set up access for it using the **BDD** identification.

For more information about setting up two addresses with different settings for the same instance, see the [installation and configuration manual] (index.php?module=documentationGetFile&filename=technical/installation_en/collec_installation_configuration.pdf&mode=attachment#subsection.2.3.8), chapter 2.3.8 *Configuring the installation folder, special case: having several instances with the same code*.

Translated with www.DeepL.com/Translator (free version)
