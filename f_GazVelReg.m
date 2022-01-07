function [G0,GAZ1,G1,VEL1] = f_GazVelReg(COLGAZE,TRD,TRL,EMO,GAZ,VEL)

GLOBAL_;

GAZ1 = GAZ; VEL1 = VEL;
N = length(TRD);

G0 = zeros(N,3); 
% ! Beware. the more low values the more i gazes j
icolg = [COLGAZE.GAZE21,COLGAZE.GAZE31]; G0(:,1) = mean(GAZ(:,icolg),2);
icolg = [COLGAZE.GAZE12,COLGAZE.GAZE32]; G0(:,2) = mean(GAZ(:,icolg),2);
icolg = [COLGAZE.GAZE13,COLGAZE.GAZE23]; G0(:,3) = mean(GAZ(:,icolg),2);
G1 = G0;
% emo = unique(EMO);

for triad = 1 : NTRIAD
    for trial = 1 : NGROUPMEASURE
        
        % Cut this triad/trial data
        It = and(TRD == triad, TRL == trial);
        
        EMOt = EMO(It);
        GAZt = GAZ(It,:); G0t = G0(It,:);
        GAZt1 = GAZt; G0t1 = G0t;
        VELt = VEL(It,:); VELt1 = VELt;
        
        % Find the leader the more gazed
        moyG0t = mean(G0t);
        [mm1,iLead1] = min(moyG0t);
        
        if iLead1 == 1
            icolg = [COLGAZE.GAZE21,COLGAZE.GAZE31];
            % Find the one that gazes the more the leader
            [mm2,iX2] = min(mean(GAZt(:,icolg)));
            if iX2 == 1, iLead2 = 2; iLead3 = 3; end % 2 gazes more 1
            if iX2 == 2, iLead2 = 3; iLead3 = 2; end % 3 gazes more 1
        end
        if iLead1 == 2
            icolg = [COLGAZE.GAZE12,COLGAZE.GAZE32];
            % Find the one that gaze the more the leader
            [mm2,iX2] = min(mean(GAZt(:,icolg)));
            if iX2 == 1, iLead2 = 1; iLead3 = 3; end % 1 gazes more 2
            if iX2 == 2, iLead2 = 3; iLead3 = 1; end % 3 gazes more 2
        end
        if iLead1 == 3
            icolg = [COLGAZE.GAZE13,COLGAZE.GAZE23];
            % Find the one that gazes the more the leader
            [mm2,iX2] = min(mean(GAZt(:,icolg)));
            if iX2 == 1, iLead2 = 1; iLead3 = 2; end % 1 gazes more 3
            if iX2 == 2, iLead2 = 2; iLead3 = 1; end % 2 gazes more 3
        end
        
        emo = unique(EMOt);
        
        if emo == 3 % positive
            
            r1 = 0.2 * rand(1) + 0.7;
            GAZt1(:,icolg) = r1 * GAZt(:,icolg); % the leader is more gazed
            G0t1(:,iLead1) = mean(GAZt1(:,icolg),2);
            % Regulate vel - iLead2 do as iLead1
            r2 = randi([10,20],1); % entre 0.1 et 0.2s
            moy1 = mean(VELt(:,iLead1));
            moy2 = mean(VELt(:,iLead2));
            vlead = VELt(:,iLead1);
            %             vshift = [vlead(r2 : end);vlead(1 : r2-1)];
            vshift = [VELt(1 : r2-1,iLead2);vlead(1 : end - r2+1)];
            % vshift = vshift - min(vshift);
            moy3 = mean(vshift);
            alpha = moy2 - moy3;
            vshift = vshift + alpha;
            moy22 = mean(vshift);
            vshift = vshift - min(vshift);
            
            VELt1(:,iLead2) = vshift;
        end
        
        if emo == 1 % negative
            
            r1 = 0.2 * rand(1) + 1.1;
            GAZt1(:,icolg) = r1 * GAZt(:,icolg); % the leader is less gazed
            G0t1(:,iLead1) = mean(GAZt1(:,icolg),2);

            % Regulate vel - iLead2 do the contrary to iLead1
            r2 = randi([10,20],1); % entre 0.1 et 0.2s
            moy1 = mean(VELt(:,iLead1));
            moy2 = mean(VELt(:,iLead3));
            vlead = VELt(:,iLead1);
            vshift = [vlead(r2 : end);vlead(1 : r2-1)];
            vshift1 = 2 * moy1 - vshift;
            vshift1 = vshift1 - min(vshift1);
            moy1 = mean(vshift1);
            moy11 = mean(vshift);
            vshift1 = moy2 * vshift1 / moy1;
            moy22 = mean(vshift1);
            VELt1(:,iLead3) = vshift1;
        end

        % Update Data
        GAZ1(It,:) = GAZt1; 
        VEL1(It,:) = VELt1;
        
        figure(3)
        subplot(221), plot(G0t)
        title(['emo: ', num2str(emo),', Lead1:',num2str(iLead1),' ,Lead2:',num2str(iLead2)])
        legend('1','2','3');
        subplot(222), plot(G0t1), %title(['emo: ', num2str(emo)])
        subplot(223), plot(VELt), %title(['emo: ', num2str(emo)])
        subplot(224), plot(VELt1), %title(['emo: ', num2str(emo)])
        'a'
    end
end

G1 = G0;
% ! Beware. the more low values the more i gazes j
icolg = [COLGAZE.GAZE21,COLGAZE.GAZE31]; G1(:,1) = mean(GAZ1(:,icolg),2);
icolg = [COLGAZE.GAZE12,COLGAZE.GAZE32]; G1(:,2) = mean(GAZ1(:,icolg),2);
icolg = [COLGAZE.GAZE13,COLGAZE.GAZE23]; G1(:,3) = mean(GAZ1(:,icolg),2);

