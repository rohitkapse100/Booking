public class WrapperCIC10 {
    public class WrapperClass {
        public string Flag;
        public string Name;
        public string Phone;
    }
    public static WrapperClass GetWrapper(){
        WrapperClass wrap = new WrapperClass();
        wrap.Flag = '1';
        wrap.Name = 'Rohit';
        wrap.phone = '128718781';
        return wrap;
    }

}