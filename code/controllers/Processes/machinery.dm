/datum/controller/process/machinery/setup()
	name = "machinery"
	schedule_interval = 20 // every 2 seconds

/datum/controller/process/machinery/doWork()
	process_power()
	process_machines()

/datum/controller/process/machinery/proc/process_machines()
	for(var/obj/machinery/M in machines)
		if(M && isnull(M.gcDestroyed))
			#ifdef PROFILE_MACHINES
			var/time_start = world.timeofday
			#endif

			if(M.process() == PROCESS_KILL)
				//M.inMachineList = 0 We don't use this debugging function
				machines.Remove(M)
				continue

			if(M && M.use_power)
				M.auto_use_power()

			#ifdef PROFILE_MACHINES
			var/time_end = world.timeofday

			if(!(M.type in machine_profiling))
				machine_profiling[M.type] = 0

			machine_profiling[M.type] += (time_end - time_start)
			#endif
		else
			machines -= M

		scheck()

/datum/controller/process/machinery/proc/process_power()
	for(var/datum/powernet/powerNetwork in powernets)
		if(istype(powerNetwork) && isnull(powerNetwork.gcDestroyed))
			powerNetwork.reset()
			scheck()
			continue
		else
			powernets -= powerNetwork
