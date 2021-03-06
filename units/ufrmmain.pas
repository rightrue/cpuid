{-----------------------------------
 Main window of application
-------------------------------------
 Simple form that display processor
 basic information such as vendor name,
 brand string, and supported features
-------------------------------------
(c) 2017 Zamrony P. Juhara <zamronypj@yahoo.com>
http://github.com/zamronypj/cpuid
-------------------------------------}
unit ufrmmain;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, CpuInterface;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    labelFrequency: TLabel;
    labelProcessorFrequency: TLabel;
    labelFeatures: TLabel;
    labelProcessorFeatures: TLabel;
    labelStepping: TLabel;
    labelProcessorStepping: TLabel;
    labelVendor: TLabel;
    labelCpuid: TLabel;
    labelName: TLabel;
    labelFamily: TLabel;
    labelModel: TLabel;
    labelProcessorModel: TLabel;
    labelProcessorFamily: TLabel;
    labelProcessorName: TLabel;
    labelCPUIDSupport: TLabel;
    labelVendorName: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    function supportedFeature(const cpuIntf : ICpuIdentifier; const feature: string) : string;
    function reportAllSupportedFeatures(const cpuIntf : ICpuIdentifier) : string;
  public
  end;

var
  frmMain: TfrmMain;

implementation
uses cpu;

{$R *.lfm}

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
var processor : ICpuIdentifier;
begin
   processor := TCpuIdentifier.Create();
   labelCPUIDSupport.Caption:= 'not supported';
   if (processor.cpuidSupported()) then
   begin
      labelCPUIDSupport.Caption:= 'supported';
   end;
   labelVendorName.Caption := processor.vendorName();
   labelProcessorName.Caption := processor.processorName();
   labelProcessorFamily.Caption := inttoStr(processor.family());
   labelProcessorModel.Caption := inttoStr(processor.model());
   labelProcessorStepping.Caption := inttoStr(processor.stepping());
   labelProcessorFeatures.Caption := reportAllSupportedFeatures(processor);
   labelProcessorFrequency.Caption := format('%d Mhz', [processor.baseFrequency()]);
end;

{**
 * Return feature string if it is supported
 *}
function TfrmMain.supportedFeature(const cpuIntf: ICpuIdentifier; const feature: string): string;
begin
   result := '';
   if (cpuIntf.hasFeature(feature)) then
   begin
      result := feature;
   end;
end;

function TfrmMain.reportAllSupportedFeatures(const cpuIntf: ICpuIdentifier): string;
const
   startFeatureIndex = 0;
   endFeatureIndex = 58;
var features : array [startFeatureIndex..endFeatureIndex] of string = (
      'SSE3', 'PCLMULQDQ', 'DTES64', 'MONITOR', 'DS-CPL', 'VMX',
      'SMX', 'EIST', 'TM2', 'SSSE3', 'CNXT-ID', 'SDBG', 'FMA',
      'CMPXCHG16B', 'xTPR', 'PDCM', 'PCID', 'DCA', 'SSE4_1',
      'SSE4_2', 'x2APIC', 'MOVBE', 'POPCNT', 'TSC-DEADLINE',
      'AES', 'XSAVE', 'OSXSAVE', 'AVX', 'F16C',
      'RDRAND', 'FPU', 'VME', 'DE', 'PSE', 'TSC', 'MSR',
      'PAE', 'MCE', 'CX8', 'APIC', 'SEP', 'MTRR', 'PGE',
      'MCA', 'CMOV', 'PAT', 'PSE-36', 'PSN', 'CLFSH', 'DS',
      'ACPI', 'MMX', 'FXSR', 'SSE', 'SSE2', 'SS', 'HTT', 'TM', 'PBE'
    );

    i:integer;
    tmp:string;
begin
   result:='';
   for i := startFeatureIndex to endFeatureIndex do
   begin
      tmp:= supportedFeature(cpuIntf, features[i]);
      if (length(tmp) > 0) then
      begin
         result:= result + tmp + ' ';
      end;
   end;
end;

end.

