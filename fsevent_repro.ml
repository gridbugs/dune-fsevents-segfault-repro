open Stdune


module Event = Fsevents.Event

let main () =
  let dir = Temp.create Dir ~prefix:"fsevents_dune" ~suffix:"" in
  Sys.chdir (Path.to_string dir);
  let cwd = Sys.getcwd () in
  let fsevent_r = ref None in
  let fsevent =
    Fsevents.create ~paths:[ cwd ] ~latency:0.0 ~f:(fun _ ->
        Fsevents.stop (Option.value_exn !fsevent_r);
        raise Exit)
  in
  fsevent_r := Some fsevent;
  let runloop = Fsevents.RunLoop.in_current_thread () in
  Fsevents.start fsevent runloop;
  match Fsevents.RunLoop.run_current_thread runloop with
  | Ok () -> ()
  | Error e -> raise e

let () = main ()
