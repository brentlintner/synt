declare module "walk-sync" {
  interface WalkSyncOptions {
    directories? : boolean;
  }

  function walk_sync(
    target : string,
    opts? : WalkSyncOptions
  ) : string[];

  export = walk_sync
}
