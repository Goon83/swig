%module cpp11_type_aliasing

// Type aliasing seg fault : Github issue #424

%warnfilter(SWIGWARN_CPP11_ALIAS_DECLARATION) Target;

%inline %{

namespace Halide {

struct Target {
  int bits;
  Target(int bits=32) : bits(bits) {}
};

class NamesInterface {
public:
  using Target = Halide::Target;
};

Target get_host_target() { 
  return Target();
}

namespace Internal {

template <typename T> class GeneratorParam {
  T value;
public:
  GeneratorParam(const char *name, const T &v) : value(v) {}

  T getValue() { 
    return value;
  }
};

class GeneratorBase : public NamesInterface {
public:
  GeneratorParam<Target> target{ "target", Halide::get_host_target() };
};

}
}
%}

%template(Halide_Target) Halide::Internal::GeneratorParam<Halide::Target>;
