#MockClustering
Experimental modifications to the sorting toolchain in at-core.

## How to Use

1.  Simply clone the repository and add "+mock" directory to your Matlab path. You could also just run setPath.m in the project directory to do so.
2.  To see if it works, type
  ` mock.Experimenter
  In Matlab. If this works without a problem, you are good to go. If you get error message like "permission denied", you probably don't have access right to the underlying database (edgarSandbox). If this happens, either change the database pointed to in +mock/getSchema.m, or contact Edgar Walker to be granted access permissions.
