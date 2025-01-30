As we know, in UVM, there are sub phases parallel to run_phase:

pre_reset_phase(), reset_phase(), post_reset_phase(): Phases involved in reset activity.
pre_configure_phase(), configure_phase(), post_configure_phase(): Phases involved in configuring DUT.
pre_main_phase(), main_phase(), post_main_phase(): Phases involved in driving main stimulus to the DUT.
pre_shutdown_phase(), shutdown_phase and post_shutdown_phase(): Phases involved in settling down the DUT after driving main stimulus.
Using these phases instead of using only run_phase, we can achieve synchronization between all components of verification environment also easily test reset functionality.

In reset testing, user drives random sequence to the DUT and in between data transmission, reset is applied followed by driving restart sequence. We will see how the reset functionality could be
easily tested using phases parallel to run_phase and phase jump feature of UVM.
