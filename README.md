Cdd
===================
2016-10-13



Go fast to any directory via a bookmarks bash system.



What is it?
-------------
This is a fork from the excellent [bashmarks script](https://github.com/huyng/bashmarks/blob/master/bashmarks.sh) by huyng.


I've just added an "o" method that opens the directory on a mac, and removed some code I knew I wouldn't need (like zsh compatible code, and auto completion code).



Install
-----------

Download the cdd.sh script somewhere on your machine (/path/to/cdd.sh for instance).

Open your .bash_profile and append this line to it:

```bash
source "/path/to/cdd.sh"
```

Restart your terminal.

Now you can use it.


Documentation
------------------

- s &lt;bookmark_name> -  Save the current directory as &lt;bookmark_name>
- g &lt;bookmark_name> -  Go (cd) to the directory associated with &lt;bookmark_name>
- o &lt;bookmark_name> -  Open the directory associated with &lt;bookmark_name>
- p &lt;bookmark_name> -  Print the directory associated with &lt;bookmark_name>
- d &lt;bookmark_name> -  Deletes the bookmark referenced by &lt;bookmark_name>
- l -  List all available bookmarks
- &lt;any_previous_command> h -  Help




