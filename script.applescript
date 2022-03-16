on run

  set theQuery to "{query}"
  set finderSelection to ""
  set theTarget to ""
  set defaultTarget to (path to home folder as alias)
  -- comment line above and uncomment line below to open desktop instead of user home when there's no selection or open folder in the Finder:
  -- set defaultTarget to (path to desktop folder as alias)

  if theQuery is "" then
      tell application "Finder"
          set finderSelection to (get selection)
          if length of finderSelection is greater than 0 then
              set theTarget to finderSelection
          else
              try
                  set theTarget to (folder of the front window as alias)
              on error
                  set theTarget to defaultTarget
              end try
          end if

          tell application "Visual Studio Code"
              open theTarget as alias
          end tell

      end tell
  else
      try
          set targets to {}
          set oldDelimiters to text item delimiters
          set text item delimiters to tab
          set qArray to every text item of theQuery
          set text item delimiters to oldDelimiters
          repeat with atarget in qArray

              if atarget starts with "~" then
                  set userHome to POSIX path of (path to home folder)
                  if userHome ends with "/" then
                      set userHome to characters 1 thru -2 of userHome as string
                  end if

                  try
                      set atarget to userHome & characters 2 thru -1 of atarget as string
                  on error
                      set atarget to userHome
                  end try

              end if

              set targetAlias to ((POSIX file atarget) as alias)
              set targets to targets & targetAlias
          end repeat

          set theTarget to targets

          tell application "Visual Studio Code"
              open theTarget
          end tell

      on error
          return (atarget as string) & " is not a valid file or folder path."
      end try
  end if

  return theQuery
end run