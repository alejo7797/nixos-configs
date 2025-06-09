{
  users = {

    # Declarative users.
    mutableUsers = false;

    # We disable root account login.
    users.root.hashedPassword = "!";

  };
}
