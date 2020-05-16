# Attract romlist to hyperlist xml converter
Little tool to convert attract romlists to hyperlist xml files.

![Screenshot](/docs/screenshot.png)

## information
i needed xml / dat files for some of the attract related raspberry pi images i had used to be able to use don's 
hyperspin tools (rom renamer) and verify my roms to rebuild and rename them to names needed by the romlists from attract.

This little tool will try to convert these romslists from attract to hyperspin xml files which you can load in don's hyperspin tools and
then use fuzzy name matching to find / rename your roms from multiple directories. CRC is not possible as attract does not store it in 
the romlists.

## how to use
Select your attract romlist folder and then press the button to generate the xml files. The xml files will be created in a subfolder called `hyperspin` of your selected romlist folder
