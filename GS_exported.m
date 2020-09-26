classdef GS_exported < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                       matlab.ui.Figure
        GridLayout                     matlab.ui.container.GridLayout
        GroundStationLabel             matlab.ui.control.Label
        IndicatorLamp                  matlab.ui.control.Lamp
        ActivationSwitch               matlab.ui.control.Switch
        TxLampLabel                    matlab.ui.control.Label
        TxLamp                         matlab.ui.control.Lamp
        RxLampLabel                    matlab.ui.control.Label
        RxLamp                         matlab.ui.control.Lamp
        TabGroup                       matlab.ui.container.TabGroup
        GyroTab                        matlab.ui.container.Tab
        GridLayout2                    matlab.ui.container.GridLayout
        PhaiGaugeLabel                 matlab.ui.control.Label
        PhaiGauge                      matlab.ui.control.SemicircularGauge
        ThetaGaugeLabel                matlab.ui.control.Label
        ThetaGauge                     matlab.ui.control.SemicircularGauge
        EbsaiGaugeLabel                matlab.ui.control.Label
        EbsaiGauge                     matlab.ui.control.SemicircularGauge
        EditField_2                    matlab.ui.control.NumericEditField
        EditField_1                    matlab.ui.control.NumericEditField
        EditField_3                    matlab.ui.control.NumericEditField
        RequestDataButton              matlab.ui.control.Button
        TransmittedCommandEditFieldLabel  matlab.ui.control.Label
        TransmittedCommandEditField    matlab.ui.control.EditField
        RecievedCommandEditFieldLabel  matlab.ui.control.Label
        RecievedCommandEditField       matlab.ui.control.EditField
        AccelerationTab                matlab.ui.container.Tab
        GridLayout3                    matlab.ui.container.GridLayout
        EditField_4                    matlab.ui.control.NumericEditField
        EditField_5                    matlab.ui.control.NumericEditField
        EditField_6                    matlab.ui.control.NumericEditField
        RequestDataButton_2            matlab.ui.control.Button
        Acceleration_yGaugeLabel       matlab.ui.control.Label
        Acceleration_yGauge            matlab.ui.control.SemicircularGauge
        Acceleration_zGaugeLabel       matlab.ui.control.Label
        Acceleration_zGauge            matlab.ui.control.SemicircularGauge
        Acceleration_xGaugeLabel       matlab.ui.control.Label
        Acceleration_xGauge            matlab.ui.control.SemicircularGauge
        RecievedCommandEditField_2Label  matlab.ui.control.Label
        RecievedCommandEditField_2     matlab.ui.control.EditField
        TransmittedCommandEditField_2Label  matlab.ui.control.Label
        TransmittedCommandEditField_2  matlab.ui.control.EditField
        UltraSonicTab                  matlab.ui.container.Tab
        GridLayout7                    matlab.ui.container.GridLayout
        GetButton                      matlab.ui.control.Button
        TransmittedCommandEditField_5Label  matlab.ui.control.Label
        TransmittedCommandEditField_5  matlab.ui.control.EditField
        RecievedCommandEditField_4Label  matlab.ui.control.Label
        RecievedCommandEditField_4     matlab.ui.control.EditField
        TakeButton                     matlab.ui.control.Button
        Lamp                           matlab.ui.control.Lamp
        EditField_10                   matlab.ui.control.NumericEditField
        TempTab                        matlab.ui.container.Tab
        GridLayout6                    matlab.ui.container.GridLayout
        EditField_7                    matlab.ui.control.NumericEditField
        TemperatureGaugeLabel          matlab.ui.control.Label
        TemperatureGauge               matlab.ui.control.LinearGauge
        RequestDataButton_3            matlab.ui.control.Button
        TransmittedCommandEditField_3Label  matlab.ui.control.Label
        TransmittedCommandEditField_3  matlab.ui.control.EditField
        RecievedCommandEditField_3Label  matlab.ui.control.Label
        RecievedCommandEditField_3     matlab.ui.control.EditField
        MotorRPMTab                    matlab.ui.container.Tab
        GridLayout5                    matlab.ui.container.GridLayout
        EditField_8                    matlab.ui.control.NumericEditField
        SendContRPMButton              matlab.ui.control.Button
        Motor1KnobLabel                matlab.ui.control.Label
        Motor1Knob                     matlab.ui.control.Knob
        EditField_9                    matlab.ui.control.NumericEditField
        Motor2KnobLabel                matlab.ui.control.Label
        Motor2Knob                     matlab.ui.control.Knob
        TransmittedCommandEditField_4Label  matlab.ui.control.Label
        TransmittedCommandEditField_4  matlab.ui.control.EditField
        SendPulseRPMButton             matlab.ui.control.Button
        PulseDurationEditFieldLabel    matlab.ui.control.Label
        PulseDurationEditField         matlab.ui.control.NumericEditField
        NumberofPulsesEditFieldLabel   matlab.ui.control.Label
        NumberofPulsesEditField        matlab.ui.control.NumericEditField
        BluetoothDeviceEditFieldLabel  matlab.ui.control.Label
        BluetoothDeviceEditField       matlab.ui.control.EditField
        ResetButton                    matlab.ui.control.Button
    end

    
    properties (Access = public)
        bt % Description
    end


    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            delete(instrfindall);
            instrhwinfo('Bluetooth','HC-05');
            app.bt = Bluetooth('HC-05',1);
        end

        % Value changed function: BluetoothDeviceEditField
        function BluetoothDeviceEditFieldValueChanged(app, event)
%             value = app.BluetoothDeviceEditField.Value;
%             delete(instrfindall);
%             instrhwinfo('Bluetooth',value);
%             app.bt = Bluetooth(value,1);
        end

        % Value changed function: ActivationSwitch
        function ActivationSwitchValueChanged(app, event)
            value = app.ActivationSwitch.Value;
            if value == "On"
                app.IndicatorLamp.Color=[1.00,0.00,0.00];
                fopen(app.bt);       
                app.IndicatorLamp.Color=[0.13,0.55,0.13];
                app.BluetoothDeviceEditField.Value=app.bt.RemoteName;
            else 
                fclose(app.bt);
                app.IndicatorLamp.Color=[1.00,1.00,0.07];
                app.BluetoothDeviceEditField.Value='NaN';
            end
        end

        % Button pushed function: RequestDataButton
        function RequestDataButtonPushed(app, event)
            flushinput(app.bt);
            flushoutput(app.bt);
            TxC=packing('gyro','00','06');
            app.TxLamp.Color=[0.49,0.18,0.56];
            fwrite(app.bt,TxC);
            TxC=dec2hex(TxC)';
            [R, C]=size(TxC);
            TxC=reshape(TxC,[1 R*C]);
            app.TransmittedCommandEditField.Value=TxC;
            while app.bt.TransferStatus~="idle"
                app.TxLamp.Color=[0.49,0.18,0.56];  
            end
            app.TxLamp.Color=[1.00,1.00,1.00];
            app.RxLamp.Color=[0.49,0.18,0.56];
            RxC=fread(app.bt,8);
            RxC=dec2hex(RxC)';
            [R, C]=size(RxC);
            RxC=reshape(RxC,[1 R*C]);
            app.RecievedCommandEditField.Value=RxC;
            while app.bt.TransferStatus~="idle"
                app.RxLamp.Color=[0.49,0.18,0.56];  
            end
            app.RxLamp.Color=[1.00,1.00,1.00];
            data=unpacking(RxC);
            app.EditField_1.Value=data(1);
            app.PhaiGauge.Value=data(1);
            app.EditField_2.Value=data(2);
            app.ThetaGauge.Value=data(2);
            app.EditField_3.Value=data(3);
            app.EbsaiGauge.Value=data(3);
        end

        % Value changed function: EditField_1
        function EditField_1ValueChanged(app, event)
            value = app.EditField_1.Value;
            app.PhaiGauge.Value=value;
        end

        % Value changed function: EditField_2
        function EditField_2ValueChanged(app, event)
            value = app.EditField_2.Value;
            app.ThetaGauge.Value=value;
        end

        % Value changed function: EditField_3
        function EditField_3ValueChanged(app, event)
            value = app.EditField_3.Value;
            app.EbsaiGauge.Value=value;
        end

        % Button pushed function: RequestDataButton_2
        function RequestDataButton_2Pushed(app, event)
            flushinput(app.bt);
            flushoutput(app.bt);
            TxC=packing('accel','00','06');
            app.TxLamp.Color=[0.49,0.18,0.56];
            fwrite(app.bt,TxC);
            TxC=dec2hex(TxC)';
            [R, C]=size(TxC);
            TxC=reshape(TxC,[1 R*C]);
            app.TransmittedCommandEditField_2.Value=TxC;
            while app.bt.TransferStatus~="idle"
                app.TxLamp.Color=[0.49,0.18,0.56];  
            end
            app.TxLamp.Color=[1.00,1.00,1.00];
            app.RxLamp.Color=[0.49,0.18,0.56];
            RxC=fread(app.bt,8);
            RxC=dec2hex(RxC)';
            [R, C]=size(RxC);
            RxC=reshape(RxC,[1 R*C]);
            app.RecievedCommandEditField_2.Value=RxC;
            while app.bt.TransferStatus~="idle"
                app.RxLamp.Color=[0.49,0.18,0.56];  
            end
            app.RxLamp.Color=[1.00,1.00,1.00];
            data=unpacking(RxC);
            app.EditField_4.Value=data(1);
            app.Acceleration_xGauge.Value=data(1);
            app.EditField_5.Value=data(2);
            app.Acceleration_yGauge.Value=data(2);
            app.EditField_6.Value=data(3); 
             app.Acceleration_zGauge.Value=data(3);
        end

        % Button pushed function: RequestDataButton_3
        function RequestDataButton_3Pushed(app, event)
            flushinput(app.bt);
            flushoutput(app.bt);
            TxC=packing('temp','00','02');
            app.TxLamp.Color=[0.49,0.18,0.56];
            fwrite(app.bt,TxC);
            TxC=dec2hex(TxC)';
            [R, C]=size(TxC);
            TxC=reshape(TxC,[1 R*C]);
            app.TransmittedCommandEditField_3.Value=TxC;
            while app.bt.TransferStatus~="idle"
                app.TxLamp.Color=[0.49,0.18,0.56];  
            end
            app.TxLamp.Color=[1.00,1.00,1.00];
            app.RxLamp.Color=[0.49,0.18,0.56];
            RxC=fread(app.bt,6);
            RxC=dec2hex(RxC)';
            [R, C]=size(RxC);
            RxC=reshape(RxC,[1 R*C]);
            app.RecievedCommandEditField_3.Value=RxC;
            while app.bt.TransferStatus~="idle"
                app.RxLamp.Color=[0.49,0.18,0.56];  
            end
            app.RxLamp.Color=[1.00,1.00,1.00];
            data=unpacking(RxC);
            whos data
            app.EditField_7.Value=data;
            app.TemperatureGauge.Value=data;
        end

        % Value changed function: EditField_8
        function EditField_8ValueChanged(app, event)
            value = app.EditField_8.Value;
            app.Motor1Knob.Value=value;
        end

        % Value changed function: Motor1Knob
        function Motor1KnobValueChanged(app, event)
            value = app.Motor1Knob.Value;
            app.EditField_8.Value=value;
        end

        % Value changed function: EditField_9
        function EditField_9ValueChanged(app, event)
            value = app.EditField_9.Value;
            app.Motor2Knob.Value=value;
        end

        % Value changed function: Motor2Knob
        function Motor2KnobValueChanged(app, event)
            value = app.Motor2Knob.Value;
            app.app.EditField_9.Value=value;
        end

        % Button pushed function: SendContRPMButton
        function SendContRPMButtonPushed(app, event)
            if app.EditField_8.Value~=0
                flushinput(app.bt);
                flushoutput(app.bt);
                TxC=packing('motor_1',app.EditField_8.Value,'02');
                app.TxLamp.Color=[0.49,0.18,0.56];
                fwrite(app.bt,TxC);
                TxC=dec2hex(TxC)';
                [R, C]=size(TxC);
                TxC=reshape(TxC,[1 R*C]);
                app.TransmittedCommandEditField_4.Value=TxC;
                while app.bt.TransferStatus~="idle"
                    app.TxLamp.Color=[0.49,0.18,0.56];  
                end
                app.TxLamp.Color=[1.00,1.00,1.00];
            end
            if app.EditField_9.Value~=0
                flushinput(app.bt);
                flushoutput(app.bt);
                TxC=packing('motor_2',app.EditField_9.Value,'02');
                app.TxLamp.Color=[0.49,0.18,0.56];
                fwrite(app.bt,TxC);
                TxC=dec2hex(TxC)';
                [R, C]=size(TxC);
                TxC=reshape(TxC,[1 R*C]);
                app.TransmittedCommandEditField_4.Value=TxC;
                while app.bt.TransferStatus~="idle"
                    app.TxLamp.Color=[0.49,0.18,0.56];  
                end
                app.TxLamp.Color=[1.00,1.00,1.00];
            end
        end

        % Value changed function: EditField_4
        function EditField_4ValueChanged(app, event)
            value = app.EditField_4.Value;
            app.Acceleration_xGauge.Value=value;
        end

        % Value changed function: EditField_5
        function EditField_5ValueChanged(app, event)
            value = app.EditField_5.Value;
            app.Acceleration_yGauge.Value=value;
        end

        % Value changed function: EditField_6
        function EditField_6ValueChanged(app, event)
            value = app.EditField_6.Value;
            app.Acceleration_zGauge.Value=value;
        end

        % Button pushed function: TakeButton
        function TakeButtonPushed(app, event)
            flushinput(app.bt);
            flushoutput(app.bt);
            TxC=packing('ultratake','00','00');
            app.TxLamp.Color=[0.49,0.18,0.56];
            fwrite(app.bt,TxC);
            TxC=dec2hex(TxC)';
            [R, C]=size(TxC);
            TxC=reshape(TxC,[1 R*C]);
            app.TransmittedCommandEditField_5.Value=TxC;
            while app.bt.TransferStatus~="idle"
                app.TxLamp.Color=[0.49,0.18,0.56];  
            end
            app.TxLamp.Color=[1.00,1.00,1.00];
        end

        % Button pushed function: GetButton
        function GetButtonPushed(app, event)
            flushinput(app.bt);
            flushoutput(app.bt);
            TxC=packing('ultraget','00','02');
            app.TxLamp.Color=[0.49,0.18,0.56];
            fwrite(app.bt,TxC);
            TxC=dec2hex(TxC)';
            [R, C]=size(TxC);
            TxC=reshape(TxC,[1 R*C]);
            app.TransmittedCommandEditField_5.Value=TxC;
            while app.bt.TransferStatus~="idle"
                app.TxLamp.Color=[0.49,0.18,0.56];  
            end
            app.TxLamp.Color=[1.00,1.00,1.00];
            app.RxLamp.Color=[0.49,0.18,0.56];
            RxC=fread(app.bt,6);
            RxC=dec2hex(RxC)';
            [R, C]=size(RxC);
            RxC=reshape(RxC,[1 R*C]);
            app.RecievedCommandEditField_4.Value=RxC;
            while app.bt.TransferStatus~="idle"
                app.RxLamp.Color=[0.49,0.18,0.56];  
            end
            app.RxLamp.Color=[1.00,1.00,1.00];
            data=unpacking(RxC);
            app.Lamp.Color=[0.00,0.00,1.00];
            app.EditField_10.Value=data;
        end

        % Button pushed function: ResetButton
        function ResetButtonPushed(app, event)
            clc
            clear vars
        end

        % Button pushed function: SendPulseRPMButton
        function SendPulseRPMButtonPushed(app, event)
             if app.EditField_8.Value~=0
                flushinput(app.bt);
                flushoutput(app.bt);
                TxC=packing('motor_1',app.EditField_8.Value,'02');
                TxC_1=packing('motor_1',1,'02');
                app.TxLamp.Color=[0.49,0.18,0.56];
                for i=1:(app.NumberofPulsesEditField.Value)
                fwrite(app.bt,TxC);
                pause(app.PulseDurationEditField.Value);
                fwrite(app.bt,TxC_1);
                pause(app.PulseDurationEditField.Value);
                end
                TxC=dec2hex(TxC)';
                [R, C]=size(TxC);
                TxC=reshape(TxC,[1 R*C]);
                app.TransmittedCommandEditField_4.Value=TxC;
                while app.bt.TransferStatus~="idle"
                    app.TxLamp.Color=[0.49,0.18,0.56];  
                end
                app.TxLamp.Color=[1.00,1.00,1.00];
            end
            if app.EditField_9.Value~=0
                flushinput(app.bt);
                flushoutput(app.bt);
                TxC=packing('motor_2',app.EditField_9.Value,'02');
                TxC_1=packing('motor_2',1,'02');
                app.TxLamp.Color=[0.49,0.18,0.56];
                for i=1:(app.NumberofPulsesEditField.Value)
                fwrite(app.bt,TxC);
                pause(app.PulseDurationEditField.Value);
                fwrite(app.bt,TxC_1);
                pause(app.PulseDurationEditField.Value);
                end
                TxC=dec2hex(TxC)';
                [R, C]=size(TxC);
                TxC=reshape(TxC,[1 R*C]);
                app.TransmittedCommandEditField_4.Value=TxC;
                while app.bt.TransferStatus~="idle"
                    app.TxLamp.Color=[0.49,0.18,0.56];  
                end
                app.TxLamp.Color=[1.00,1.00,1.00];
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Color = [1 1 1];
            app.UIFigure.Position = [100 100 996 609];
            app.UIFigure.Name = 'UI Figure';
            app.UIFigure.WindowState = 'fullscreen';

            % Create GridLayout
            app.GridLayout = uigridlayout(app.UIFigure);
            app.GridLayout.ColumnWidth = {30, '1.13x', '2x', 57.99, 31, 57.99, 31};
            app.GridLayout.RowHeight = {19.99, '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create GroundStationLabel
            app.GroundStationLabel = uilabel(app.GridLayout);
            app.GroundStationLabel.HorizontalAlignment = 'center';
            app.GroundStationLabel.FontName = 'Times New Roman';
            app.GroundStationLabel.FontSize = 50;
            app.GroundStationLabel.FontWeight = 'bold';
            app.GroundStationLabel.FontAngle = 'italic';
            app.GroundStationLabel.FontColor = [0.5882 0.0118 1];
            app.GroundStationLabel.Layout.Row = [1 2];
            app.GroundStationLabel.Layout.Column = 3;
            app.GroundStationLabel.Text = 'Ground Station      ';

            % Create IndicatorLamp
            app.IndicatorLamp = uilamp(app.GridLayout);
            app.IndicatorLamp.Layout.Row = 1;
            app.IndicatorLamp.Layout.Column = 1;
            app.IndicatorLamp.Color = [1 1 0.0706];

            % Create ActivationSwitch
            app.ActivationSwitch = uiswitch(app.GridLayout, 'slider');
            app.ActivationSwitch.ValueChangedFcn = createCallbackFcn(app, @ActivationSwitchValueChanged, true);
            app.ActivationSwitch.FontName = 'Times New Roman';
            app.ActivationSwitch.FontAngle = 'italic';
            app.ActivationSwitch.Layout.Row = 1;
            app.ActivationSwitch.Layout.Column = [6 7];

            % Create TxLampLabel
            app.TxLampLabel = uilabel(app.GridLayout);
            app.TxLampLabel.HorizontalAlignment = 'center';
            app.TxLampLabel.FontName = 'Times New Roman';
            app.TxLampLabel.FontSize = 14;
            app.TxLampLabel.FontWeight = 'bold';
            app.TxLampLabel.FontAngle = 'italic';
            app.TxLampLabel.Layout.Row = 2;
            app.TxLampLabel.Layout.Column = 6;
            app.TxLampLabel.Text = 'Tx';

            % Create TxLamp
            app.TxLamp = uilamp(app.GridLayout);
            app.TxLamp.Layout.Row = 2;
            app.TxLamp.Layout.Column = 7;
            app.TxLamp.Color = [1 1 1];

            % Create RxLampLabel
            app.RxLampLabel = uilabel(app.GridLayout);
            app.RxLampLabel.HorizontalAlignment = 'center';
            app.RxLampLabel.FontName = 'Times New Roman';
            app.RxLampLabel.FontSize = 14;
            app.RxLampLabel.FontWeight = 'bold';
            app.RxLampLabel.FontAngle = 'italic';
            app.RxLampLabel.Layout.Row = 2;
            app.RxLampLabel.Layout.Column = 4;
            app.RxLampLabel.Text = 'Rx';

            % Create RxLamp
            app.RxLamp = uilamp(app.GridLayout);
            app.RxLamp.Layout.Row = 2;
            app.RxLamp.Layout.Column = 5;
            app.RxLamp.Color = [1 1 1];

            % Create TabGroup
            app.TabGroup = uitabgroup(app.GridLayout);
            app.TabGroup.Layout.Row = [3 10];
            app.TabGroup.Layout.Column = [1 7];

            % Create GyroTab
            app.GyroTab = uitab(app.TabGroup);
            app.GyroTab.Title = 'Gyro ';
            app.GyroTab.BackgroundColor = [1 1 1];

            % Create GridLayout2
            app.GridLayout2 = uigridlayout(app.GyroTab);
            app.GridLayout2.ColumnWidth = {'1x', '1x', '1x'};
            app.GridLayout2.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create PhaiGaugeLabel
            app.PhaiGaugeLabel = uilabel(app.GridLayout2);
            app.PhaiGaugeLabel.HorizontalAlignment = 'center';
            app.PhaiGaugeLabel.FontName = 'Times New Roman';
            app.PhaiGaugeLabel.FontSize = 25;
            app.PhaiGaugeLabel.FontAngle = 'italic';
            app.PhaiGaugeLabel.Layout.Row = 3;
            app.PhaiGaugeLabel.Layout.Column = 1;
            app.PhaiGaugeLabel.Text = 'Phai';

            % Create PhaiGauge
            app.PhaiGauge = uigauge(app.GridLayout2, 'semicircular');
            app.PhaiGauge.Limits = [-180 180];
            app.PhaiGauge.Layout.Row = [1 2];
            app.PhaiGauge.Layout.Column = 1;

            % Create ThetaGaugeLabel
            app.ThetaGaugeLabel = uilabel(app.GridLayout2);
            app.ThetaGaugeLabel.HorizontalAlignment = 'center';
            app.ThetaGaugeLabel.FontName = 'Times New Roman';
            app.ThetaGaugeLabel.FontSize = 25;
            app.ThetaGaugeLabel.FontAngle = 'italic';
            app.ThetaGaugeLabel.Layout.Row = 3;
            app.ThetaGaugeLabel.Layout.Column = 2;
            app.ThetaGaugeLabel.Text = 'Theta';

            % Create ThetaGauge
            app.ThetaGauge = uigauge(app.GridLayout2, 'semicircular');
            app.ThetaGauge.Limits = [-180 180];
            app.ThetaGauge.Layout.Row = [1 2];
            app.ThetaGauge.Layout.Column = 2;

            % Create EbsaiGaugeLabel
            app.EbsaiGaugeLabel = uilabel(app.GridLayout2);
            app.EbsaiGaugeLabel.HorizontalAlignment = 'center';
            app.EbsaiGaugeLabel.FontName = 'Times New Roman';
            app.EbsaiGaugeLabel.FontSize = 25;
            app.EbsaiGaugeLabel.FontAngle = 'italic';
            app.EbsaiGaugeLabel.Layout.Row = 3;
            app.EbsaiGaugeLabel.Layout.Column = 3;
            app.EbsaiGaugeLabel.Text = 'Ebsai';

            % Create EbsaiGauge
            app.EbsaiGauge = uigauge(app.GridLayout2, 'semicircular');
            app.EbsaiGauge.Limits = [-180 180];
            app.EbsaiGauge.Layout.Row = [1 2];
            app.EbsaiGauge.Layout.Column = 3;

            % Create EditField_2
            app.EditField_2 = uieditfield(app.GridLayout2, 'numeric');
            app.EditField_2.ValueChangedFcn = createCallbackFcn(app, @EditField_2ValueChanged, true);
            app.EditField_2.HorizontalAlignment = 'center';
            app.EditField_2.FontName = 'Times New Roman';
            app.EditField_2.FontSize = 25;
            app.EditField_2.FontAngle = 'italic';
            app.EditField_2.Layout.Row = 4;
            app.EditField_2.Layout.Column = 2;

            % Create EditField_1
            app.EditField_1 = uieditfield(app.GridLayout2, 'numeric');
            app.EditField_1.ValueChangedFcn = createCallbackFcn(app, @EditField_1ValueChanged, true);
            app.EditField_1.HorizontalAlignment = 'center';
            app.EditField_1.FontName = 'Times New Roman';
            app.EditField_1.FontSize = 25;
            app.EditField_1.FontAngle = 'italic';
            app.EditField_1.Layout.Row = 4;
            app.EditField_1.Layout.Column = 1;

            % Create EditField_3
            app.EditField_3 = uieditfield(app.GridLayout2, 'numeric');
            app.EditField_3.ValueChangedFcn = createCallbackFcn(app, @EditField_3ValueChanged, true);
            app.EditField_3.HorizontalAlignment = 'center';
            app.EditField_3.FontName = 'Times New Roman';
            app.EditField_3.FontSize = 25;
            app.EditField_3.FontAngle = 'italic';
            app.EditField_3.Layout.Row = 4;
            app.EditField_3.Layout.Column = 3;

            % Create RequestDataButton
            app.RequestDataButton = uibutton(app.GridLayout2, 'push');
            app.RequestDataButton.ButtonPushedFcn = createCallbackFcn(app, @RequestDataButtonPushed, true);
            app.RequestDataButton.FontName = 'Times New Roman';
            app.RequestDataButton.FontSize = 30;
            app.RequestDataButton.FontWeight = 'bold';
            app.RequestDataButton.FontAngle = 'italic';
            app.RequestDataButton.Layout.Row = 7;
            app.RequestDataButton.Layout.Column = 3;
            app.RequestDataButton.Text = 'Request Data';

            % Create TransmittedCommandEditFieldLabel
            app.TransmittedCommandEditFieldLabel = uilabel(app.GridLayout2);
            app.TransmittedCommandEditFieldLabel.FontName = 'Times New Roman';
            app.TransmittedCommandEditFieldLabel.FontSize = 25;
            app.TransmittedCommandEditFieldLabel.FontAngle = 'italic';
            app.TransmittedCommandEditFieldLabel.Layout.Row = 6;
            app.TransmittedCommandEditFieldLabel.Layout.Column = 1;
            app.TransmittedCommandEditFieldLabel.Text = 'Transmitted Command';

            % Create TransmittedCommandEditField
            app.TransmittedCommandEditField = uieditfield(app.GridLayout2, 'text');
            app.TransmittedCommandEditField.FontName = 'Times New Roman';
            app.TransmittedCommandEditField.FontSize = 25;
            app.TransmittedCommandEditField.FontAngle = 'italic';
            app.TransmittedCommandEditField.Layout.Row = 6;
            app.TransmittedCommandEditField.Layout.Column = [2 3];

            % Create RecievedCommandEditFieldLabel
            app.RecievedCommandEditFieldLabel = uilabel(app.GridLayout2);
            app.RecievedCommandEditFieldLabel.FontName = 'Times New Roman';
            app.RecievedCommandEditFieldLabel.FontSize = 25;
            app.RecievedCommandEditFieldLabel.FontAngle = 'italic';
            app.RecievedCommandEditFieldLabel.Layout.Row = 5;
            app.RecievedCommandEditFieldLabel.Layout.Column = 1;
            app.RecievedCommandEditFieldLabel.Text = 'Recieved Command';

            % Create RecievedCommandEditField
            app.RecievedCommandEditField = uieditfield(app.GridLayout2, 'text');
            app.RecievedCommandEditField.FontName = 'Times New Roman';
            app.RecievedCommandEditField.FontSize = 25;
            app.RecievedCommandEditField.FontAngle = 'italic';
            app.RecievedCommandEditField.Layout.Row = 5;
            app.RecievedCommandEditField.Layout.Column = [2 3];

            % Create AccelerationTab
            app.AccelerationTab = uitab(app.TabGroup);
            app.AccelerationTab.Title = 'Acceleration';
            app.AccelerationTab.BackgroundColor = [1 1 1];

            % Create GridLayout3
            app.GridLayout3 = uigridlayout(app.AccelerationTab);
            app.GridLayout3.ColumnWidth = {'1x', '1x', '1x'};
            app.GridLayout3.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create EditField_4
            app.EditField_4 = uieditfield(app.GridLayout3, 'numeric');
            app.EditField_4.ValueChangedFcn = createCallbackFcn(app, @EditField_4ValueChanged, true);
            app.EditField_4.HorizontalAlignment = 'center';
            app.EditField_4.FontName = 'Times New Roman';
            app.EditField_4.FontSize = 25;
            app.EditField_4.FontAngle = 'italic';
            app.EditField_4.Layout.Row = 4;
            app.EditField_4.Layout.Column = 1;

            % Create EditField_5
            app.EditField_5 = uieditfield(app.GridLayout3, 'numeric');
            app.EditField_5.ValueChangedFcn = createCallbackFcn(app, @EditField_5ValueChanged, true);
            app.EditField_5.HorizontalAlignment = 'center';
            app.EditField_5.FontName = 'Times New Roman';
            app.EditField_5.FontSize = 25;
            app.EditField_5.FontAngle = 'italic';
            app.EditField_5.Layout.Row = 4;
            app.EditField_5.Layout.Column = 2;

            % Create EditField_6
            app.EditField_6 = uieditfield(app.GridLayout3, 'numeric');
            app.EditField_6.ValueChangedFcn = createCallbackFcn(app, @EditField_6ValueChanged, true);
            app.EditField_6.HorizontalAlignment = 'center';
            app.EditField_6.FontName = 'Times New Roman';
            app.EditField_6.FontSize = 25;
            app.EditField_6.FontAngle = 'italic';
            app.EditField_6.Layout.Row = 4;
            app.EditField_6.Layout.Column = 3;

            % Create RequestDataButton_2
            app.RequestDataButton_2 = uibutton(app.GridLayout3, 'push');
            app.RequestDataButton_2.ButtonPushedFcn = createCallbackFcn(app, @RequestDataButton_2Pushed, true);
            app.RequestDataButton_2.FontName = 'Times New Roman';
            app.RequestDataButton_2.FontSize = 30;
            app.RequestDataButton_2.FontWeight = 'bold';
            app.RequestDataButton_2.FontAngle = 'italic';
            app.RequestDataButton_2.Layout.Row = 7;
            app.RequestDataButton_2.Layout.Column = 3;
            app.RequestDataButton_2.Text = 'Request Data';

            % Create Acceleration_yGaugeLabel
            app.Acceleration_yGaugeLabel = uilabel(app.GridLayout3);
            app.Acceleration_yGaugeLabel.HorizontalAlignment = 'center';
            app.Acceleration_yGaugeLabel.FontName = 'Times New Roman';
            app.Acceleration_yGaugeLabel.FontSize = 25;
            app.Acceleration_yGaugeLabel.FontAngle = 'italic';
            app.Acceleration_yGaugeLabel.Layout.Row = 3;
            app.Acceleration_yGaugeLabel.Layout.Column = 2;
            app.Acceleration_yGaugeLabel.Text = 'Acceleration_y';

            % Create Acceleration_yGauge
            app.Acceleration_yGauge = uigauge(app.GridLayout3, 'semicircular');
            app.Acceleration_yGauge.Limits = [-100 100];
            app.Acceleration_yGauge.Layout.Row = [1 2];
            app.Acceleration_yGauge.Layout.Column = 2;

            % Create Acceleration_zGaugeLabel
            app.Acceleration_zGaugeLabel = uilabel(app.GridLayout3);
            app.Acceleration_zGaugeLabel.HorizontalAlignment = 'center';
            app.Acceleration_zGaugeLabel.FontName = 'Times New Roman';
            app.Acceleration_zGaugeLabel.FontSize = 25;
            app.Acceleration_zGaugeLabel.FontAngle = 'italic';
            app.Acceleration_zGaugeLabel.Layout.Row = 3;
            app.Acceleration_zGaugeLabel.Layout.Column = 3;
            app.Acceleration_zGaugeLabel.Text = 'Acceleration_z';

            % Create Acceleration_zGauge
            app.Acceleration_zGauge = uigauge(app.GridLayout3, 'semicircular');
            app.Acceleration_zGauge.Limits = [-100 100];
            app.Acceleration_zGauge.Layout.Row = [1 2];
            app.Acceleration_zGauge.Layout.Column = 3;

            % Create Acceleration_xGaugeLabel
            app.Acceleration_xGaugeLabel = uilabel(app.GridLayout3);
            app.Acceleration_xGaugeLabel.HorizontalAlignment = 'center';
            app.Acceleration_xGaugeLabel.FontName = 'Times New Roman';
            app.Acceleration_xGaugeLabel.FontSize = 25;
            app.Acceleration_xGaugeLabel.FontAngle = 'italic';
            app.Acceleration_xGaugeLabel.Layout.Row = 3;
            app.Acceleration_xGaugeLabel.Layout.Column = 1;
            app.Acceleration_xGaugeLabel.Text = 'Acceleration_x';

            % Create Acceleration_xGauge
            app.Acceleration_xGauge = uigauge(app.GridLayout3, 'semicircular');
            app.Acceleration_xGauge.Limits = [-100 100];
            app.Acceleration_xGauge.Layout.Row = [1 2];
            app.Acceleration_xGauge.Layout.Column = 1;

            % Create RecievedCommandEditField_2Label
            app.RecievedCommandEditField_2Label = uilabel(app.GridLayout3);
            app.RecievedCommandEditField_2Label.FontName = 'Times New Roman';
            app.RecievedCommandEditField_2Label.FontSize = 25;
            app.RecievedCommandEditField_2Label.FontAngle = 'italic';
            app.RecievedCommandEditField_2Label.Layout.Row = 5;
            app.RecievedCommandEditField_2Label.Layout.Column = 1;
            app.RecievedCommandEditField_2Label.Text = 'Recieved Command';

            % Create RecievedCommandEditField_2
            app.RecievedCommandEditField_2 = uieditfield(app.GridLayout3, 'text');
            app.RecievedCommandEditField_2.FontName = 'Times New Roman';
            app.RecievedCommandEditField_2.FontSize = 25;
            app.RecievedCommandEditField_2.FontAngle = 'italic';
            app.RecievedCommandEditField_2.Layout.Row = 5;
            app.RecievedCommandEditField_2.Layout.Column = [2 3];

            % Create TransmittedCommandEditField_2Label
            app.TransmittedCommandEditField_2Label = uilabel(app.GridLayout3);
            app.TransmittedCommandEditField_2Label.FontName = 'Times New Roman';
            app.TransmittedCommandEditField_2Label.FontSize = 25;
            app.TransmittedCommandEditField_2Label.FontAngle = 'italic';
            app.TransmittedCommandEditField_2Label.Layout.Row = 6;
            app.TransmittedCommandEditField_2Label.Layout.Column = 1;
            app.TransmittedCommandEditField_2Label.Text = 'Transmitted Command';

            % Create TransmittedCommandEditField_2
            app.TransmittedCommandEditField_2 = uieditfield(app.GridLayout3, 'text');
            app.TransmittedCommandEditField_2.FontName = 'Times New Roman';
            app.TransmittedCommandEditField_2.FontSize = 25;
            app.TransmittedCommandEditField_2.FontAngle = 'italic';
            app.TransmittedCommandEditField_2.Layout.Row = 6;
            app.TransmittedCommandEditField_2.Layout.Column = [2 3];

            % Create UltraSonicTab
            app.UltraSonicTab = uitab(app.TabGroup);
            app.UltraSonicTab.Title = 'Ultra Sonic';

            % Create GridLayout7
            app.GridLayout7 = uigridlayout(app.UltraSonicTab);
            app.GridLayout7.ColumnWidth = {'1x', '1x', '1x'};
            app.GridLayout7.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create GetButton
            app.GetButton = uibutton(app.GridLayout7, 'push');
            app.GetButton.ButtonPushedFcn = createCallbackFcn(app, @GetButtonPushed, true);
            app.GetButton.FontName = 'Times New Roman';
            app.GetButton.FontSize = 30;
            app.GetButton.FontWeight = 'bold';
            app.GetButton.FontAngle = 'italic';
            app.GetButton.Layout.Row = 7;
            app.GetButton.Layout.Column = 3;
            app.GetButton.Text = 'Get';

            % Create TransmittedCommandEditField_5Label
            app.TransmittedCommandEditField_5Label = uilabel(app.GridLayout7);
            app.TransmittedCommandEditField_5Label.FontName = 'Times New Roman';
            app.TransmittedCommandEditField_5Label.FontSize = 25;
            app.TransmittedCommandEditField_5Label.FontAngle = 'italic';
            app.TransmittedCommandEditField_5Label.Layout.Row = 6;
            app.TransmittedCommandEditField_5Label.Layout.Column = 1;
            app.TransmittedCommandEditField_5Label.Text = 'Transmitted Command';

            % Create TransmittedCommandEditField_5
            app.TransmittedCommandEditField_5 = uieditfield(app.GridLayout7, 'text');
            app.TransmittedCommandEditField_5.FontName = 'Times New Roman';
            app.TransmittedCommandEditField_5.FontSize = 25;
            app.TransmittedCommandEditField_5.FontAngle = 'italic';
            app.TransmittedCommandEditField_5.Layout.Row = 6;
            app.TransmittedCommandEditField_5.Layout.Column = [2 3];

            % Create RecievedCommandEditField_4Label
            app.RecievedCommandEditField_4Label = uilabel(app.GridLayout7);
            app.RecievedCommandEditField_4Label.FontName = 'Times New Roman';
            app.RecievedCommandEditField_4Label.FontSize = 25;
            app.RecievedCommandEditField_4Label.FontAngle = 'italic';
            app.RecievedCommandEditField_4Label.Layout.Row = 5;
            app.RecievedCommandEditField_4Label.Layout.Column = 1;
            app.RecievedCommandEditField_4Label.Text = 'Recieved Command';

            % Create RecievedCommandEditField_4
            app.RecievedCommandEditField_4 = uieditfield(app.GridLayout7, 'text');
            app.RecievedCommandEditField_4.FontName = 'Times New Roman';
            app.RecievedCommandEditField_4.FontSize = 25;
            app.RecievedCommandEditField_4.FontAngle = 'italic';
            app.RecievedCommandEditField_4.Layout.Row = 5;
            app.RecievedCommandEditField_4.Layout.Column = [2 3];

            % Create TakeButton
            app.TakeButton = uibutton(app.GridLayout7, 'push');
            app.TakeButton.ButtonPushedFcn = createCallbackFcn(app, @TakeButtonPushed, true);
            app.TakeButton.FontName = 'Times New Roman';
            app.TakeButton.FontSize = 30;
            app.TakeButton.FontWeight = 'bold';
            app.TakeButton.FontAngle = 'italic';
            app.TakeButton.Layout.Row = 7;
            app.TakeButton.Layout.Column = 1;
            app.TakeButton.Text = 'Take';

            % Create Lamp
            app.Lamp = uilamp(app.GridLayout7);
            app.Lamp.Layout.Row = [1 2];
            app.Lamp.Layout.Column = 2;
            app.Lamp.Color = [1 1 1];

            % Create EditField_10
            app.EditField_10 = uieditfield(app.GridLayout7, 'numeric');
            app.EditField_10.HorizontalAlignment = 'center';
            app.EditField_10.FontName = 'Times New Roman';
            app.EditField_10.FontSize = 25;
            app.EditField_10.FontAngle = 'italic';
            app.EditField_10.Layout.Row = 3;
            app.EditField_10.Layout.Column = [1 3];

            % Create TempTab
            app.TempTab = uitab(app.TabGroup);
            app.TempTab.Title = 'Temp';
            app.TempTab.BackgroundColor = [1 1 1];

            % Create GridLayout6
            app.GridLayout6 = uigridlayout(app.TempTab);
            app.GridLayout6.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create EditField_7
            app.EditField_7 = uieditfield(app.GridLayout6, 'numeric');
            app.EditField_7.HorizontalAlignment = 'center';
            app.EditField_7.FontName = 'Times New Roman';
            app.EditField_7.FontSize = 25;
            app.EditField_7.FontAngle = 'italic';
            app.EditField_7.Layout.Row = 4;
            app.EditField_7.Layout.Column = [1 2];

            % Create TemperatureGaugeLabel
            app.TemperatureGaugeLabel = uilabel(app.GridLayout6);
            app.TemperatureGaugeLabel.HorizontalAlignment = 'center';
            app.TemperatureGaugeLabel.FontName = 'Times New Roman';
            app.TemperatureGaugeLabel.FontSize = 25;
            app.TemperatureGaugeLabel.FontAngle = 'italic';
            app.TemperatureGaugeLabel.Layout.Row = 3;
            app.TemperatureGaugeLabel.Layout.Column = [1 2];
            app.TemperatureGaugeLabel.Text = 'Temperature';

            % Create TemperatureGauge
            app.TemperatureGauge = uigauge(app.GridLayout6, 'linear');
            app.TemperatureGauge.Limits = [-20 100];
            app.TemperatureGauge.Layout.Row = [1 2];
            app.TemperatureGauge.Layout.Column = [1 2];

            % Create RequestDataButton_3
            app.RequestDataButton_3 = uibutton(app.GridLayout6, 'push');
            app.RequestDataButton_3.ButtonPushedFcn = createCallbackFcn(app, @RequestDataButton_3Pushed, true);
            app.RequestDataButton_3.FontName = 'Times New Roman';
            app.RequestDataButton_3.FontSize = 30;
            app.RequestDataButton_3.FontWeight = 'bold';
            app.RequestDataButton_3.FontAngle = 'italic';
            app.RequestDataButton_3.Layout.Row = 7;
            app.RequestDataButton_3.Layout.Column = 2;
            app.RequestDataButton_3.Text = 'Request Data';

            % Create TransmittedCommandEditField_3Label
            app.TransmittedCommandEditField_3Label = uilabel(app.GridLayout6);
            app.TransmittedCommandEditField_3Label.FontName = 'Times New Roman';
            app.TransmittedCommandEditField_3Label.FontSize = 25;
            app.TransmittedCommandEditField_3Label.FontAngle = 'italic';
            app.TransmittedCommandEditField_3Label.Layout.Row = 5;
            app.TransmittedCommandEditField_3Label.Layout.Column = 1;
            app.TransmittedCommandEditField_3Label.Text = 'Transmitted Command';

            % Create TransmittedCommandEditField_3
            app.TransmittedCommandEditField_3 = uieditfield(app.GridLayout6, 'text');
            app.TransmittedCommandEditField_3.FontName = 'Times New Roman';
            app.TransmittedCommandEditField_3.FontSize = 25;
            app.TransmittedCommandEditField_3.FontAngle = 'italic';
            app.TransmittedCommandEditField_3.Layout.Row = 5;
            app.TransmittedCommandEditField_3.Layout.Column = 2;

            % Create RecievedCommandEditField_3Label
            app.RecievedCommandEditField_3Label = uilabel(app.GridLayout6);
            app.RecievedCommandEditField_3Label.FontName = 'Times New Roman';
            app.RecievedCommandEditField_3Label.FontSize = 25;
            app.RecievedCommandEditField_3Label.FontAngle = 'italic';
            app.RecievedCommandEditField_3Label.Layout.Row = 6;
            app.RecievedCommandEditField_3Label.Layout.Column = 1;
            app.RecievedCommandEditField_3Label.Text = 'Recieved Command';

            % Create RecievedCommandEditField_3
            app.RecievedCommandEditField_3 = uieditfield(app.GridLayout6, 'text');
            app.RecievedCommandEditField_3.FontName = 'Times New Roman';
            app.RecievedCommandEditField_3.FontSize = 25;
            app.RecievedCommandEditField_3.FontAngle = 'italic';
            app.RecievedCommandEditField_3.Layout.Row = 6;
            app.RecievedCommandEditField_3.Layout.Column = 2;

            % Create MotorRPMTab
            app.MotorRPMTab = uitab(app.TabGroup);
            app.MotorRPMTab.Title = 'Motor RPM';
            app.MotorRPMTab.BackgroundColor = [1 1 1];

            % Create GridLayout5
            app.GridLayout5 = uigridlayout(app.MotorRPMTab);
            app.GridLayout5.ColumnWidth = {'1x', '1x', '1x', '1x'};
            app.GridLayout5.RowHeight = {'1x', '1x', '1x', '1x', '1x', '1x', '1x', '1x'};

            % Create EditField_8
            app.EditField_8 = uieditfield(app.GridLayout5, 'numeric');
            app.EditField_8.ValueChangedFcn = createCallbackFcn(app, @EditField_8ValueChanged, true);
            app.EditField_8.HorizontalAlignment = 'center';
            app.EditField_8.FontName = 'Times New Roman';
            app.EditField_8.FontSize = 25;
            app.EditField_8.FontAngle = 'italic';
            app.EditField_8.Layout.Row = 5;
            app.EditField_8.Layout.Column = [1 2];

            % Create SendContRPMButton
            app.SendContRPMButton = uibutton(app.GridLayout5, 'push');
            app.SendContRPMButton.ButtonPushedFcn = createCallbackFcn(app, @SendContRPMButtonPushed, true);
            app.SendContRPMButton.FontName = 'Times New Roman';
            app.SendContRPMButton.FontSize = 25;
            app.SendContRPMButton.FontWeight = 'bold';
            app.SendContRPMButton.FontAngle = 'italic';
            app.SendContRPMButton.Layout.Row = 8;
            app.SendContRPMButton.Layout.Column = 4;
            app.SendContRPMButton.Text = 'Send Cont. RPM';

            % Create Motor1KnobLabel
            app.Motor1KnobLabel = uilabel(app.GridLayout5);
            app.Motor1KnobLabel.HorizontalAlignment = 'center';
            app.Motor1KnobLabel.FontName = 'Times New Roman';
            app.Motor1KnobLabel.FontSize = 25;
            app.Motor1KnobLabel.FontAngle = 'italic';
            app.Motor1KnobLabel.Layout.Row = 4;
            app.Motor1KnobLabel.Layout.Column = [1 2];
            app.Motor1KnobLabel.Text = {'Motor 1'; ''};

            % Create Motor1Knob
            app.Motor1Knob = uiknob(app.GridLayout5, 'continuous');
            app.Motor1Knob.Limits = [-255 255];
            app.Motor1Knob.ValueChangedFcn = createCallbackFcn(app, @Motor1KnobValueChanged, true);
            app.Motor1Knob.Layout.Row = [1 3];
            app.Motor1Knob.Layout.Column = [1 2];

            % Create EditField_9
            app.EditField_9 = uieditfield(app.GridLayout5, 'numeric');
            app.EditField_9.ValueChangedFcn = createCallbackFcn(app, @EditField_9ValueChanged, true);
            app.EditField_9.HorizontalAlignment = 'center';
            app.EditField_9.FontName = 'Times New Roman';
            app.EditField_9.FontSize = 25;
            app.EditField_9.FontAngle = 'italic';
            app.EditField_9.Layout.Row = 5;
            app.EditField_9.Layout.Column = [3 4];

            % Create Motor2KnobLabel
            app.Motor2KnobLabel = uilabel(app.GridLayout5);
            app.Motor2KnobLabel.HorizontalAlignment = 'center';
            app.Motor2KnobLabel.FontName = 'Times New Roman';
            app.Motor2KnobLabel.FontSize = 25;
            app.Motor2KnobLabel.FontAngle = 'italic';
            app.Motor2KnobLabel.Layout.Row = 4;
            app.Motor2KnobLabel.Layout.Column = [3 4];
            app.Motor2KnobLabel.Text = 'Motor 2';

            % Create Motor2Knob
            app.Motor2Knob = uiknob(app.GridLayout5, 'continuous');
            app.Motor2Knob.Limits = [-255 255];
            app.Motor2Knob.ValueChangedFcn = createCallbackFcn(app, @Motor2KnobValueChanged, true);
            app.Motor2Knob.Layout.Row = [1 3];
            app.Motor2Knob.Layout.Column = [3 4];

            % Create TransmittedCommandEditField_4Label
            app.TransmittedCommandEditField_4Label = uilabel(app.GridLayout5);
            app.TransmittedCommandEditField_4Label.FontName = 'Times New Roman';
            app.TransmittedCommandEditField_4Label.FontSize = 25;
            app.TransmittedCommandEditField_4Label.FontAngle = 'italic';
            app.TransmittedCommandEditField_4Label.Layout.Row = 6;
            app.TransmittedCommandEditField_4Label.Layout.Column = 1;
            app.TransmittedCommandEditField_4Label.Text = 'Transmitted Command';

            % Create TransmittedCommandEditField_4
            app.TransmittedCommandEditField_4 = uieditfield(app.GridLayout5, 'text');
            app.TransmittedCommandEditField_4.FontName = 'Times New Roman';
            app.TransmittedCommandEditField_4.FontSize = 25;
            app.TransmittedCommandEditField_4.FontAngle = 'italic';
            app.TransmittedCommandEditField_4.Layout.Row = 6;
            app.TransmittedCommandEditField_4.Layout.Column = [2 4];

            % Create SendPulseRPMButton
            app.SendPulseRPMButton = uibutton(app.GridLayout5, 'push');
            app.SendPulseRPMButton.ButtonPushedFcn = createCallbackFcn(app, @SendPulseRPMButtonPushed, true);
            app.SendPulseRPMButton.FontName = 'Times New Roman';
            app.SendPulseRPMButton.FontSize = 25;
            app.SendPulseRPMButton.FontWeight = 'bold';
            app.SendPulseRPMButton.FontAngle = 'italic';
            app.SendPulseRPMButton.Layout.Row = 8;
            app.SendPulseRPMButton.Layout.Column = 1;
            app.SendPulseRPMButton.Text = 'Send Pulse RPM';

            % Create PulseDurationEditFieldLabel
            app.PulseDurationEditFieldLabel = uilabel(app.GridLayout5);
            app.PulseDurationEditFieldLabel.HorizontalAlignment = 'center';
            app.PulseDurationEditFieldLabel.FontName = 'Times New Roman';
            app.PulseDurationEditFieldLabel.FontSize = 25;
            app.PulseDurationEditFieldLabel.FontAngle = 'italic';
            app.PulseDurationEditFieldLabel.Layout.Row = 7;
            app.PulseDurationEditFieldLabel.Layout.Column = 2;
            app.PulseDurationEditFieldLabel.Text = 'Pulse Duration';

            % Create PulseDurationEditField
            app.PulseDurationEditField = uieditfield(app.GridLayout5, 'numeric');
            app.PulseDurationEditField.HorizontalAlignment = 'center';
            app.PulseDurationEditField.FontName = 'Times New Roman';
            app.PulseDurationEditField.FontSize = 25;
            app.PulseDurationEditField.FontAngle = 'italic';
            app.PulseDurationEditField.Layout.Row = 8;
            app.PulseDurationEditField.Layout.Column = 2;

            % Create NumberofPulsesEditFieldLabel
            app.NumberofPulsesEditFieldLabel = uilabel(app.GridLayout5);
            app.NumberofPulsesEditFieldLabel.HorizontalAlignment = 'center';
            app.NumberofPulsesEditFieldLabel.FontName = 'Times New Roman';
            app.NumberofPulsesEditFieldLabel.FontSize = 25;
            app.NumberofPulsesEditFieldLabel.FontAngle = 'italic';
            app.NumberofPulsesEditFieldLabel.Layout.Row = 7;
            app.NumberofPulsesEditFieldLabel.Layout.Column = 3;
            app.NumberofPulsesEditFieldLabel.Text = 'Number of Pulses';

            % Create NumberofPulsesEditField
            app.NumberofPulsesEditField = uieditfield(app.GridLayout5, 'numeric');
            app.NumberofPulsesEditField.HorizontalAlignment = 'center';
            app.NumberofPulsesEditField.FontName = 'Times New Roman';
            app.NumberofPulsesEditField.FontSize = 25;
            app.NumberofPulsesEditField.FontAngle = 'italic';
            app.NumberofPulsesEditField.Layout.Row = 8;
            app.NumberofPulsesEditField.Layout.Column = 3;

            % Create BluetoothDeviceEditFieldLabel
            app.BluetoothDeviceEditFieldLabel = uilabel(app.GridLayout);
            app.BluetoothDeviceEditFieldLabel.HorizontalAlignment = 'center';
            app.BluetoothDeviceEditFieldLabel.FontName = 'Times New Roman';
            app.BluetoothDeviceEditFieldLabel.FontSize = 15;
            app.BluetoothDeviceEditFieldLabel.FontWeight = 'bold';
            app.BluetoothDeviceEditFieldLabel.FontAngle = 'italic';
            app.BluetoothDeviceEditFieldLabel.Layout.Row = 1;
            app.BluetoothDeviceEditFieldLabel.Layout.Column = 2;
            app.BluetoothDeviceEditFieldLabel.Text = 'Bluetooth Device';

            % Create BluetoothDeviceEditField
            app.BluetoothDeviceEditField = uieditfield(app.GridLayout, 'text');
            app.BluetoothDeviceEditField.ValueChangedFcn = createCallbackFcn(app, @BluetoothDeviceEditFieldValueChanged, true);
            app.BluetoothDeviceEditField.HorizontalAlignment = 'center';
            app.BluetoothDeviceEditField.FontName = 'Freestyle Script';
            app.BluetoothDeviceEditField.FontSize = 30;
            app.BluetoothDeviceEditField.Layout.Row = 2;
            app.BluetoothDeviceEditField.Layout.Column = 2;

            % Create ResetButton
            app.ResetButton = uibutton(app.GridLayout, 'push');
            app.ResetButton.ButtonPushedFcn = createCallbackFcn(app, @ResetButtonPushed, true);
            app.ResetButton.FontName = 'Times New Roman';
            app.ResetButton.FontWeight = 'bold';
            app.ResetButton.FontAngle = 'italic';
            app.ResetButton.Layout.Row = 1;
            app.ResetButton.Layout.Column = 4;
            app.ResetButton.Text = 'Reset';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = GS_exported

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end