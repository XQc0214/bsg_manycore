`ifndef PROFILER_VH
`define PROFILER_VH

`define DECLARE_PROFILER_INIT_FUNC(profiler_name) \
import "DPI-C" context function \
  void profiler_name``_init(int tracer_fd);

`define DECLARE_PROFILER_EXIT_FUNC(profiler_name) \
import "DPI-C" context function \
  void profiler_name``_exit();

`define DECLARE_PROFILER_IS_INIT_FUNC(profiler_name) \
import "DPI-C" context function \
  int profiler_name``_is_init();

`define DECLARE_PROFILER_IS_EXIT_FUNC(profiler_name) \
import "DPI-C" context function \
  int profiler_name``_is_exit();

`define DECLARE_PROFILER_TRACE_FD_FUNC(profiler_name) \
import  "DPI-C" context function \
  int profiler_name``_trace_fd();

`define DECLARE_PROFILER_LOCK_FUNC(profiler_name) \
import "DPI-C" context function \
  void profiler_name``_lock();

`define DECLARE_PROFILER_UNLOCK_FUNC(profiler_name) \
import "DPI-C" context function \
  void profiler_name``_unlock();


`define DEFINE_PROFILER_INITIAL_BLOCK(profiler_name, trace_file_name, trace_file_header) \
initial begin \
  profiler_name``_lock();  \
  if (profiler_name``_is_init() == 0) begin \
    int trace_fd = $fopen(trace_file_name, "w"); \
    profiler_name``_init(trace_fd); \
    $fwrite(trace_fd, trace_file_header); \
  end \
  profiler_name``_unlock(); \
end

`define DEFINE_PROFILER_FINAL_BLOCK(profiler_name, trace_file_name, trace_file_header) \
  final begin \
    profiler_name``_lock(); \
    if (profiler_name``_is_exit()) begin \
      $fclose(profiler_name``_trace_fd()); \
      profiler_name``_exit(); \
    end \
    profiler_name``_unlock(); \
  end

`define DEFINE_PROFILER(profiler_name, trace_file_name, trace_file_header) \
  `DECLARE_PROFILER_INIT_FUNC(profiler_name) \
  `DECLARE_PROFILER_EXIT_FUNC(profiler_name) \
  `DECLARE_PROFILER_IS_INIT_FUNC(profiler_name) \
  `DECLARE_PROFILER_IS_EXIT_FUNC(profiler_name) \
  `DECLARE_PROFILER_TRACE_FD_FUNC(profiler_name) \
  `DECLARE_PROFILER_LOCK_FUNC(profiler_name) \
  `DECLARE_PROFILER_UNLOCK_FUNC(profiler_name) \
  `DEFINE_PROFILER_INITIAL_BLOCK(profiler_name, trace_file_name, trace_file_header) \
  `DEFINE_PROFILER_FINAL_BLOCK(profiler_name)

`endif
