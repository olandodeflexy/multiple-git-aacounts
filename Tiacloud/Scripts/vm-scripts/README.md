## VM Scaleset Startup and Shotdown Scripts

These scripts starts and stops the VM Scale set in the TIA Cloud account using a cronjob.

### Startup Script

The startup script (```startupscript.sh```) starts the VM Scaleset at 5:00 am every weekday.

### Shutdown Script

The shutdown script (```shutdownscript.sh```) starts the VM Scaleset at 5:00 pm every weekday.

## Run Scripts

Clone the project

```
  Clone the repo
```

Go to the Scripts directory

```
  cd Scripts
```

Run Starup Script

Run ```crontab -e``` 
Set  time to ```* 5 20 * *``` and set the path to the ```<path>/startupscript.sh``` script

Run Shutdown Script

Run ```crontab -e``` 
Set  time to ```* 5 20 * *``` and set the path to the ```<path>/shutdownscript.sh``` script






