import Button from "./Button";

export default function PaymentModal({ handlePayClick }) {
  return (
    <div className="fixed inset-0 w-screen h-screen modal z-50 text-white">
      <div
        className="fixed inset-0 bg-black opacity-40"
        onClick={handlePayClick}
      ></div>
      <div className="fixed w-[92%] sm:w-[70%] md:w-[60%] lg:w-[50%] top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 px-4 py-6 rounded-xl  backdrop-blur-sm border border-white/10 shadow-[0_0_40px_rgba(0,0,0,0.7)]">
        <div className="flex justify-end mx-1">
          <img
            src="/x.svg"
            alt="close"
            className="w-4 sm:w-5 cursor-pointer"
            onClick={handlePayClick}
          />
        </div>
        <div className="flex flex-col items-center">
          <h1 className="text-2xl font-semibold pb-2 text-center">
            Instructions
          </h1>
          <ol className="p-2 mb-3 w-full">
            <li>Click on Pay and you will be redirected.</li>
            <li>Select Birla Institute of Technology and Science, Goa.</li>
            <li>In the next page, select Quark 25 Registration.</li>
            <li>Fill the details required.</li>
          </ol>
          
          <Button
            
            text="PAY"
            onClick={() =>
              window.open(
                "https://www.onlinesbi.sbi/sbicollect/icollecthome.htm",
                "_blank"
              )
            }
          />
          
        </div>
      </div>
    </div>
  );
}
