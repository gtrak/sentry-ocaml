open Core_kernel
open Async_kernel

module Config = Config
module Dsn = Dsn
module Event = Event
module Exception = Exception
module Platform = Platform
module Sdk = Sdk
module Severity_level = Severity_level

(** [capture_message ?dsn message] uploads a message to Sentry using the given
    [dsn] (or looking it up in the environment). *)
val capture_message : ?dsn:Dsn.t -> string -> unit

(** [capture_exception ?dsn ?message e] records the backtrace from [e] and an
    optional message and uploads it to Sentry. *)
val capture_exception : ?dsn:Dsn.t -> ?message:string -> exn -> unit

(** [capture_error ?dsn ?message e] records the backtrace from [e] and uploads
    it to Sentry. *)
val capture_error : ?dsn:Dsn.t -> Error.t -> unit

(** [context ?dsn f] runs [f]. If [f] throws an exception, it will be
    uploaded to Sentry and then re-reraised. *)
val context : ?dsn:Dsn.t -> (unit -> 'a) -> 'a

(** [context_ignore ?dsn f] is like [context] except exceptions will not be
    re-raised. Use this if you're using Sentry in a loop where you want to
    report on errors and then continue (like in an web server). *)
val context_ignore : ?dsn:Dsn.t -> (unit -> unit) -> unit

(** [context_or_error ?dsn f] runs [f]. If [f] throws an exception or error, it
    will be uploaded to Sentry and then re-raised or returned. Note that
    [Error.t] does not handle backtraces as well as exceptions. *)
val context_or_error : ?dsn:Dsn.t -> (unit -> 'a Or_error.t) -> 'a Or_error.t

(** [context_async ?dsn f] runs [f]. If [f] throws one or more exceptions, they
    will be uploaded to Sentry. The first raised exception willl be re-raised
    (multiple exceptions could be raised to the Async monitor but only one can
    be re-raised). *)
val context_async : ?dsn:Dsn.t -> (unit -> 'a Deferred.t) -> 'a Deferred.t

(** See [context_ignore] and [context_async] *)
val context_async_ignore : ?dsn:Dsn.t -> (unit -> unit Deferred.t) -> unit Deferred.t

(** [context_async_or_error ?dsn f] runs [f]. If [f] throws an exception or
    returns an error, it will be uploaded to Sentry and then re-raised or
    returned. *)
val context_async_or_error : ?dsn:Dsn.t -> (unit -> 'a Deferred.Or_error.t) -> 'a Deferred.Or_error.t